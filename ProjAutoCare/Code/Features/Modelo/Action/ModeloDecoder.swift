//
//  ModeloDecoder.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 26/09/23.
//

import CoreData
import Combine
import OSLog
import SwiftyJSON

class ModeloDecoder: ObservableObject
{
    static let shared = ModeloDecoder()
    
    var logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Publisher")
    var publisherContext: NSManagedObjectContext = {
        let context = PersistenceController.shared.container.viewContext
        context.mergePolicy = NSMergePolicy( merge: .mergeByPropertyObjectTrumpMergePolicyType)
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    func fetchModelos() async throws
    {
        let url = URL(string: "https://carapi.app/api/models?year=2020")!
        
        let session = URLSession.shared
        guard let (data, response) = try? await session.data(from: url),
              let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else
        {
            logger.debug("Failed to received valid response and/or data.")
            throw ValidationError.missingData
        }
        
        do
        {
            let json =  try JSON(data: data)
            
            logger.debug("Start importing data to the store...")
            try await batchInsertModelos(from: json["data"])
            logger.debug("Finished importing data.")
        }
        catch
        {
            print(error.localizedDescription)
            throw ValidationError.wrongDataFormat(error: error)
        }
    }
    
    func batchInsertModelos(from dados: JSON) async throws
    {
        guard !dados.isEmpty else { return }
        
        let taskContext = publisherContext
        
        return try await taskContext.perform {
            
            var index = 0
            let batchRequest = NSBatchInsertRequest(entityName: "Modelo", dictionaryHandler: { dict in
                if index < dados.count {
                    let item = ["id": dados[index]["id"].rawValue, "idmarca": dados[index]["make_id"].rawValue, "nome": dados[index]["name"].rawValue]
                    dict.setDictionary(item)
                    index += 1
                    return false // Not yet complete, need to continue adding
                } else {
                    return true // index == amount, the specified number (amount) of data has been added, end batch insertion operation.
                }
            })
            batchRequest.resultType = .statusOnly
            let result = try taskContext.execute(batchRequest) as! NSBatchInsertResult
            self.logger.debug("Successfully inserted data.")
            
            // return result.result as! Bool
        }
    }
    
    func batchDeleteModels() async throws
    {
        // Specify a batch to delete with a fetch request
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: "Modelo")

        // Create a batch delete request for the
        // fetch request
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        // Specify the result of the NSBatchDeleteRequest
        // should be the NSManagedObject IDs for the
        // deleted objects
        deleteRequest.resultType = .resultTypeObjectIDs

        // Get a reference to a managed object context
        let context = publisherContext
        
        do 
        {
            // Execute the request.
            let deleteResult = try context.execute(deleteRequest) as? NSBatchDeleteResult
            
            // Extract the IDs of the deleted managed objectss from the request's result.
            if let objectIDs = deleteResult?.result as? [NSManagedObjectID] {
                
                // Merge the deletions into the app's managed object context.
                NSManagedObjectContext.mergeChanges(
                    fromRemoteContextSave: [NSDeletedObjectsKey: objectIDs],
                    into: [context]
                )
            }
        }
        catch
        {
            fatalError("Erro moc \(error.localizedDescription)")
        }
    }
}
