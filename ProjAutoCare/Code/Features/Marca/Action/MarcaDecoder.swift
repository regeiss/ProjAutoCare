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
        let context = PersistenceController.shared.container.viewContext
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
            // Decode the JSON into a data model.
            let json =  try JSON(data: data)
            
            logger.debug("Start importing data to the store...")
            // try await batchInsertMarcas(from: json["data"])
            logger.debug("Finished importing data.")
        }
        catch
        {
            print(error.localizedDescription)
            throw ValidationError.wrongDataFormat(error: error)
        }
    }
    
    func batchInsertMarcas(from dados: JSON) async throws
    {
        guard !dados.isEmpty else { return }
        
        let taskContext = publisherContext
        
        return try await taskContext.perform {
            // Number of records already added
            var index = 0
            // Create an NSBatchInsertRequest and declare a data processing closure. If dictionaryHandler returns false, Core Data will continue to call the closure to create data until the closure returns true.
            let batchRequest = NSBatchInsertRequest(entityName: "Marca", dictionaryHandler: { dict in
                if index < dados.count {
                    // Create data. The current Item has only one property, timestamp, of type Date.
                    let item = ["id": dados[index]["id"].rawValue, "nome": dados[index]["name"].rawValue]
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
}
