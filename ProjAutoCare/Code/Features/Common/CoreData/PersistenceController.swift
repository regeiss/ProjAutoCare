//
//  PersistenceController.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 21/06/23.
//

import Combine
import CoreData

class PersistenceController: ObservableObject
{
    static let authorName = "AutoCare"
    static let remoteDataImportAuthorName = "AutoCare Data Import"
    var lastHistoryToken: NSPersistentHistoryToken?
    private lazy var historyRequestQueue = DispatchQueue(label: "history")
    var subscriptions: Set<AnyCancellable> = []
    
    private lazy var tokenFileURL: URL = {
        let url = NSPersistentContainer.defaultDirectoryURL()
            .appendingPathComponent("ProjAutoCare", isDirectory: true)
        do
        {
            try FileManager.default
                .createDirectory(
                    at: url,
                    withIntermediateDirectories: true,
                    attributes: nil)
        }
        catch
        {
            // log any errors
        }
        return url.appendingPathComponent("token.data", isDirectory: false)
    }()
    
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    init(inMemory: Bool = false)
    {
        container = NSPersistentContainer(name: "AutoCare")
        let persistentStoreDescription = container.persistentStoreDescriptions.first
        
        persistentStoreDescription?.setOption(
            true as NSNumber,
            forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        persistentStoreDescription?.setOption(
            true as NSNumber,
            forKey: NSPersistentHistoryTrackingKey)
        
        if inMemory
        {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError?
            {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.transactionAuthor = PersistenceController.authorName
        
        if !inMemory
        {
            do
            {
                try container.viewContext.setQueryGenerationFrom(.current)
            }
            catch
            {
                // log any errors
            }
        }
        
        NotificationCenter.default
            .publisher(for: .NSPersistentStoreRemoteChange)
            .sink {
                self.processRemoteStoreChange($0)
            }
            .store(in: &subscriptions)
        
        loadHistoryToken()
    }
    
    func processRemoteStoreChange(_ notification: Notification)
    {
        historyRequestQueue.async
        {
            let backgroundContext = self.container.newBackgroundContext()
            backgroundContext.performAndWait
            {
                let request = NSPersistentHistoryChangeRequest
                    .fetchHistory(after: self.lastHistoryToken)
                
                if let historyFetchRequest = NSPersistentHistoryTransaction.fetchRequest
                {
                    historyFetchRequest.predicate = NSPredicate(format: "%K != %@", "author", PersistenceController.authorName)
                    request.fetchRequest = historyFetchRequest
                }
                
                do
                {
                    let result = try backgroundContext.execute(request) as?
                    NSPersistentHistoryResult
                    guard let transactions = result?.result as? [NSPersistentHistoryTransaction],
                          !transactions.isEmpty
                    else { return }
                    
                    self.mergeChanges(from: transactions)
                    if let newToken = transactions.last?.token
                    {
                        self.storeHistoryToken(newToken)
                    }
                }
                catch
                {
                    // log any errors
                }
            }
        }
    }
    
    private func loadHistoryToken()
    {
        do
        {
            let tokenData = try Data(contentsOf: tokenFileURL)
            lastHistoryToken = try NSKeyedUnarchiver
                .unarchivedObject(ofClass: NSPersistentHistoryToken.self, from: tokenData)
        }
        catch
        {
        }
    }
    
    private func storeHistoryToken(_ token: NSPersistentHistoryToken)
    {
        do
        {
            let data = try NSKeyedArchiver
                .archivedData(withRootObject: token, requiringSecureCoding: true)
            try data.write(to: tokenFileURL)
            lastHistoryToken = token
        }
        catch
        {
        }
    }
    
    private func mergeChanges(from transactions: [NSPersistentHistoryTransaction])
    {
        let context = container.viewContext
        
        context.perform
        {
            transactions.forEach { transaction in
                guard let userInfo = transaction.objectIDNotification().userInfo
                else
                {
                    return
                }
                NSManagedObjectContext
                    .mergeChanges(fromRemoteContextSave: userInfo, into: [context])
            }
        }
    }
}
