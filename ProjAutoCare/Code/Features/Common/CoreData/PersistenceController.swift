//
//  PersistenceController.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 21/06/23.
//

import Combine
import CoreData
import OSLog

class PersistenceController: ObservableObject
{
    static let authorName = "AutoCare"
    static let remoteDataImportAuthorName = "AutoCare Data Import"
    var lastHistoryToken: NSPersistentHistoryToken?
    private lazy var historyRequestQueue = DispatchQueue(label: "history")
    var subscriptions: Set<AnyCancellable> = []
    private let modelName: String
    var logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Persistence")
    
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
            logger.log("Erro gerando tokenfile")
        }
        return url.appendingPathComponent("token.data", isDirectory: false)
    }()
    
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    init(inMemory: Bool = false)
    {
        self.modelName = "AutoCare"
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
                self.logger.log("Erro abrindo store")
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
                self.logger.log("Erro setando query format")
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
                    let result = try backgroundContext.execute(request) as? NSPersistentHistoryResult
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
                    self.logger.log("Erro abrindo history queue")
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
            self.logger.log("Erro carregando token history")
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
            self.logger.log("Erro persistent history token")
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

private extension PersistenceController
{
    func seedCoreDataContainerIfFirstLaunch()
    {
        let previouslyLaunched = UserDefaults.standard.bool(forKey: "previouslyLaunched")
        if !previouslyLaunched
        {
            UserDefaults.standard.set(true, forKey: "previouslyLaunched")
            
            // Default directory where the CoreDataStack will store its files
            let directory = NSPersistentContainer.defaultDirectoryURL()
            let url = directory.appendingPathComponent(modelName + ".sqlite")
            
            // 2: Copying the SQLite file
            let seededDatabaseURL = Bundle.main.url(forResource: modelName, withExtension: "sqlite")!
            _ = try? FileManager.default.removeItem(at: url)
            
            do
            {
                try FileManager.default.copyItem(at: seededDatabaseURL, to: url)
            }
            catch let nserror as NSError
            {
                fatalError("Error: \(nserror.localizedDescription)")
            }
            
            // 3: Copying the SHM file
            let seededSHMURL = Bundle.main.url(forResource: modelName, withExtension: "sqlite-shm")!
            let shmURL = directory.appendingPathComponent(modelName + ".sqlite-shm")
            _ = try? FileManager.default.removeItem(at: shmURL)
            
            do
            {
                try FileManager.default.copyItem(at: seededSHMURL, to: shmURL)
            }
            catch let nserror as NSError
            {
                fatalError("Error: \(nserror.localizedDescription)")
            }
            
            // 4: Copying the WAL file
            let seededWALURL = Bundle.main.url(forResource: modelName, withExtension: "sqlite-wal")!
            let walURL = directory.appendingPathComponent(modelName + ".sqlite-wal")
            _ = try? FileManager.default.removeItem(at: walURL)
            
            do
            {
                try FileManager.default.copyItem(at: seededWALURL, to: walURL)
            }
            catch let nserror as NSError
            {
                fatalError("Error: \(nserror.localizedDescription)")
            }
            
            print("Seeded Core Data")
        }
    }
}
