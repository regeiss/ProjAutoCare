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
    var backGroundContext: NSManagedObjectContext = {
        let context = PersistenceController.shared.container.newBackgroundContext()
        context.mergePolicy = NSMergePolicy( merge: .mergeByPropertyObjectTrumpMergePolicyType)
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    func fetchModelos() async throws
    {
        let url = URL(string: "https://carapi.app/api/models")!
        
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
            
            batchInsertModelos(from: json["data"])
        }
        catch
        {
            print(error.localizedDescription)
            throw ValidationError.wrongDataFormat(error: error)
        }
    }
    
    func batchInsertModelos(from dados: JSON)
    {
        guard !dados.isEmpty else { return }
        
        do
        {
            backGroundContext.transactionAuthor = PersistenceController.remoteDataImportAuthorName
            
            try backGroundContext.performAndWait
            {
                var index = 0
                let batchRequest = NSBatchInsertRequest(entityName: "Modelo", dictionaryHandler: { dict in
                    if index < dados.count
                    {
                        let item = ["id": dados[index]["id"].rawValue, "idmarca": dados[index]["make_id"].rawValue, "nome": dados[index]["name"].rawValue]
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
                try backGroundContext.execute(batchRequest)
                self.logger.debug("*** Successfully inserted modelo data.")
            }
        }
        catch
        {
            self.logger.debug("Error inserting Modelo data.")
        }
    }
    
    func batchDeleteModelos() async throws
    {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: "Modelo")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        deleteRequest.resultType = .resultTypeObjectIDs
        
        do
        {
            try backGroundContext.performAndWait
            {
                let deleteResult = try backGroundContext.execute(deleteRequest) as? NSBatchDeleteResult
                
                if let objectIDs = deleteResult?.result as? [NSManagedObjectID]
                {
                    NSManagedObjectContext.mergeChanges(
                        fromRemoteContextSave: [NSDeletedObjectsKey: objectIDs], into: [backGroundContext])
                }
            }
        }
        catch
        {
            fatalError("Erro moc \(error.localizedDescription)")
        }
    }
    
    func ajustaMarcaModelo() async throws
    {
        let fetchRequest: NSFetchRequest<Modelo>
        fetchRequest = Modelo.fetchRequest()
        self.logger.debug("Iniciando ajuste modelos.")
        do
        {
            let modelos = try backGroundContext.fetch(fetchRequest)
            
            for modelo in modelos {
               
                modelo.eFabricado = buscaMarcaModelo(id: Int(modelo.idmarca))
            }
            
            self.logger.debug("Finalizando ajuste modelos.")
            try backGroundContext.save()
        }
        catch
        {
            NSLog("Erro: could not fetch objects")
        }
    }
    
    func buscaMarcaModelo(id: Int) -> Marca
    {
        let fetchRequest: NSFetchRequest<Marca> = Marca.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", id)
        fetchRequest.fetchLimit = 1
        
        do
        {
            guard let marca = try backGroundContext.fetch(fetchRequest).first
            else { return Marca()}
            return marca
        }
        catch
        {
            fatalError("Erro moc \(error.localizedDescription)")
        }
    }
}
