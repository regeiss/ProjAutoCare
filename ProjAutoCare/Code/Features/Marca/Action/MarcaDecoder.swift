//
//  MarcaDecoder.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 24/09/23.
//

import CoreData
import Combine
import OSLog
import SwiftyJSON

class MarcaDecoder: ObservableObject
{
    static let shared = MarcaDecoder()
    
    var logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Publisher")
    var publisherContext: NSManagedObjectContext = {
        let context = PersistenceController.shared.container.newBackgroundContext()
        context.mergePolicy = NSMergePolicy( merge: .mergeByPropertyObjectTrumpMergePolicyType)
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    func fetchMarcas() async throws
    {
        let url = URL(string: "https://carapi.app/api/makes")!
        
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
            try await batchInsertMarcas(from: json["data"])
            logger.debug("Finished importing data.")
        }
        catch
        {
            print(error.localizedDescription)
            throw ValidationError.wrongDataFormat(error: error)
        }
    }
    
    // TODO: Avaliar o return
    func batchInsertMarcas(from dados: JSON) async throws
    {
        guard !dados.isEmpty else { return }
        
        let taskContext = publisherContext
        
        return try await taskContext.perform {
            var index = 0
            let batchRequest = NSBatchInsertRequest(entityName: "Marca", dictionaryHandler: { dict in
                if index < dados.count 
                {
                    let item = ["id": dados[index]["id"].rawValue, "nome": dados[index]["name"].rawValue]
                    dict.setDictionary(item)
                    index += 1
                    return false
                } 
                else
                {
                    return true
                }
            })
            batchRequest.resultType = .statusOnly
            let result = try taskContext.execute(batchRequest) as! NSBatchInsertResult
            self.logger.debug("Successfully inserted data.")
            // return result.result as! Bool
        }
    }
    
    func batchDeleteMarcas() async throws
    {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: "Marca")

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        deleteRequest.resultType = .resultTypeObjectIDs

        let context = publisherContext
        
        do
        {
            let deleteResult = try context.execute(deleteRequest) as? NSBatchDeleteResult
            
            if let objectIDs = deleteResult?.result as? [NSManagedObjectID]
            {
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
