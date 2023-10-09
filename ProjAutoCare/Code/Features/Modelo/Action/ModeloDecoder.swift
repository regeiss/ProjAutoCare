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
        taskContext.transactionAuthor = PersistenceController.remoteDataImportAuthorName

        return try await taskContext.perform { [self] in
            
            var index = 0
            let batchRequest = NSBatchInsertRequest(entityName: "Modelo", dictionaryHandler: { dict in
                if index < dados.count {
                    let item = ["id": dados[index]["id"].rawValue, "idmarca": dados[index]["make_id"].rawValue, "nome": dados[index]["name"].rawValue]
                    dict.setDictionary(item)
                    index += 1
                    return false
                } else {
                    return true
                }
            })
            batchRequest.resultType = .statusOnly
            let result = try taskContext.execute(batchRequest) as! NSBatchInsertResult
            self.logger.debug("Successfully inserted data.")
            
            // ajustaMarcaModelo()
            // return result.result as! Bool
        }
    }
    
    func batchDeleteModelos() async throws
    {
        let context = publisherContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: "Modelo")

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        deleteRequest.resultType = .resultTypeObjectIDs
        
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
    
    func ajustaMarcaModelo() async throws
    {
        let context = publisherContext
        let fetchRequest: NSFetchRequest<Modelo>
        fetchRequest = Modelo.fetchRequest()
        
        do
        {
            let modelos = try context.fetch(fetchRequest)
            
            for modelo in modelos {
               
                modelo.eFabricado = buscaMarcaModelo(id: Int(modelo.idmarca))
            }
            
            try context.save()
        }
        catch
        {
            NSLog("Erro: could not fetch objects")
        }
    }
    
    func buscaMarcaModelo(id: Int) -> Marca
    {
        let context = publisherContext
        let fetchRequest: NSFetchRequest<Marca> = Marca.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", id)
        fetchRequest.fetchLimit = 1
        
        do
        {
            guard let marca = try context.fetch(fetchRequest).first
            else { return Marca()}
            return marca
        }
        catch
        {
            fatalError("Erro moc \(error.localizedDescription)")
        }
    }
}
