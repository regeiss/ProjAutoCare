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
            let dadosDictionary = json["data"]
            
            logger.debug("Start importing data to the store...")
            // try await importaMarcas(from: dic)
            logger.debug("Finished importing data.")
        }
        catch
        {
            print(error.localizedDescription)
            throw ValidationError.wrongDataFormat(error: error)
        }
    }
    
//    func importaMarcas(from dicionario: [String: Any]) async throws
//        {
//            guard !dicionario.isEmpty else { return }
//    
//            let taskContext = publisherContext
//            // Add name and author to identify source of persistent history changes.
//
//            /// - Tag: performAndWait
//            try await taskContext.perform {
//                // Execute the batch insert.
//                /// - Tag: batchInsertRequest
//                let batchInsertRequest = NSBatchInsertRequest(entity: Marca.entity(), objects: [dicionario])
//                if let fetchResult = try? taskContext.execute(batchInsertRequest),
//                   let batchInsertResult = fetchResult as? NSBatchInsertResult,
//                   let success = batchInsertResult.result as? Bool, success {
//                    return
//                }
//                self.logger.debug("Failed to execute batch insert request.")
//                throw ValidationError.batchInsertError
//            }
//    
//            logger.debug("Successfully inserted data.")
//        }
//    
//    private func newBatchInsertRequest(with marcas: [dadosDictionary]) -> NSBatchInsertRequest
//    {
//      // 1
//      var index = 0
//      let total = fireballs.count
//
//      // 2
//      let batchInsert = NSBatchInsertRequest(entity: Marca.entity()) { (managedObject: NSManagedObject) -> Bool in
//        // 3
//        guard index < total else { return true }
//
//        if let fireball = managedObject as? Fireball {
//          // 4
//          let data = fireballs[index]
//          fireball.dateTimeStamp = data.dateTimeStamp
//          fireball.radiatedEnergy = data.radiatedEnergy
//          fireball.impactEnergy = data.impactEnergy
//          fireball.latitude = data.latitude
//          fireball.longitude = data.longitude
//          fireball.altitude = data.altitude
//          fireball.velocity = data.velocity
//        }
//
//        // 5
//        index += 1
//        return false
//      }
//      return batchInsert
//    }
}
