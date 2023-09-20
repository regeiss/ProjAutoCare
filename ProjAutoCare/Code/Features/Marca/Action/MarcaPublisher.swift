//
//  MarcaPublisher.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 10/09/23.
//

import CoreData
import Combine
import OSLog

class MarcaPublisher: NSObject, ObservableObject
{
    static let shared = MarcaPublisher()
    
    var marcaCVS = CurrentValueSubject<[Marca], Never>([])
    private let marcaFetchController: NSFetchedResultsController<Marca>
    
    var logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Publisher")
    
    var publisherContext: NSManagedObjectContext = {
        let context = PersistenceController.shared.container.viewContext
        context.mergePolicy = NSMergePolicy( merge: .mergeByPropertyObjectTrumpMergePolicyType)
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    private override init()
    {
        let fetchRequest: NSFetchRequest<Marca> = Marca.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.returnsDistinctResults = true
        
        marcaFetchController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: publisherContext,
            sectionNameKeyPath: nil, cacheName: nil
        )
        
        super.init()
        
        marcaFetchController.delegate = self
        
        do
        {
            try marcaFetchController.performFetch()
            marcaCVS.value = marcaFetchController.fetchedObjects ?? []
        }
        catch
        {
            NSLog("Erro: could not fetch objects")
        }
    }
    
    func fetchMarcas() async throws
    {
        let url = URL(string: "https://carapi.app/api/makes")!
        
        let session = URLSession.shared
        guard let (data, response) = try? await session.data(from: url),
              let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            logger.debug("Failed to received valid response and/or data.")
            throw ValidationError.missingData
        }
        
        do
        {
            print("Dados \(data.count)")
            // Decode the GeoJSON into a data model.
            let jsonDecoder = JSONDecoder()
            let marcaJSON = try jsonDecoder.decode(CarAPI.self, from: data)
            let marcaPropertiesList = marcaJSON.marcaPropertiesList
            logger.debug("Received \(marcaPropertiesList.count) records.")
            
            // Import the GeoJSON into Core Data.
            logger.debug("Start importing data to the store...")
            try await importaMarcas(from: marcaPropertiesList)
            logger.debug("Finished importing data.")
        }
        catch
        {
            throw ValidationError.wrongDataFormat(error: error)
        }
    }
    
    private func importaMarcas(from propertiesList: [MarcaProperties]) async throws
    {
        guard !propertiesList.isEmpty else { return }
        
        let taskContext = publisherContext
        // Add name and author to identify source of persistent history changes.
        taskContext.name = "importContext"
        taskContext.transactionAuthor = "importQuakes"
        
        /// - Tag: performAndWait
        try await taskContext.perform {
            // Execute the batch insert.
            /// - Tag: batchInsertRequest
            let batchInsertRequest = self.newBatchInsertRequest(with: propertiesList)
            if let fetchResult = try? taskContext.execute(batchInsertRequest),
               let batchInsertResult = fetchResult as? NSBatchInsertResult,
               let success = batchInsertResult.result as? Bool, success {
                return
            }
            self.logger.debug("Failed to execute batch insert request.")
            throw ValidationError.batchInsertError
        }
        
        logger.debug("Successfully inserted data.")
    }
    
    private func newBatchInsertRequest(with propertyList: [MarcaProperties]) -> NSBatchInsertRequest {
        var index = 0
        let total = propertyList.count
        
        // Provide one dictionary at a time when the closure is called.
        let batchInsertRequest = NSBatchInsertRequest(entity: Marca.entity(), dictionaryHandler: { dictionary in
            guard index < total else { return true }
            dictionary.addEntries(from: propertyList[index].dictionaryValue)
            index += 1
            return false
        })
        return batchInsertRequest
    }
}

extension MarcaPublisher: NSFetchedResultsControllerDelegate
{
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        guard let perfis = controller.fetchedObjects as? [Marca]
        else { return }
        logger.log("Context has changed, reloading postos")
        self.marcaCVS.value = perfis
    }
}
