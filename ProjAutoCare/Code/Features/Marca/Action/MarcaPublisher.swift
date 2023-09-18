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
    
    func fetchQuakes() async throws 
    {
         let url = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson")!

         let session = URLSession.shared
         guard let (data, response) = try? await session.data(from: url),
               let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200
         else {
             logger.debug("Failed to received valid response and/or data.")
             throw ValidationError.missingData
         }

         do {
             // Decode the GeoJSON into a data model.
             let jsonDecoder = JSONDecoder()
             jsonDecoder.dateDecodingStrategy = .secondsSince1970
             let geoJSON = try jsonDecoder.decode(Datum.self, from: data)
             let quakePropertiesList = geoJSON.propertiesList
             logger.debug("Received \(quakePropertiesList.count) records.")

             // Import the GeoJSON into Core Data.
             logger.debug("Start importing data to the store...")
             try await importaMarcas(from: quakePropertiesList)
             logger.debug("Finished importing data.")
         } catch {
             throw ValidationError.wrongDataFormat(error: error)
         }
     }
    
    private func importaMarcas(from propertiesList: [Datum]) async throws
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

       private func newBatchInsertRequest(with propertyList: [Datum]) -> NSBatchInsertRequest {
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

//    var dados: [Datum]?
//    let logger = Logger.init(subsystem: Bundle.main.bundleIdentifier!, category: "main")
//
//    func importaMarcas() async
//    {
//        await viewModel.getAllMarcas()
//
//        switch viewModel.state
//        {
//        case .failed(let error):
//            let xxxx=0
//        case .na:
//            let xxxx = 0
//        case .success(let data):
//            let dicionario = getDataFromPacket(packet: data)!
//            do
//            {
//                let dicionarioPorID = try JSONSerialization.jsonObject(with: dicionario, options: []) as! [String : Any]
//                let batchInsert = NSBatchInsertRequest(entityName: "Marca", objects: [dicionarioPorID])
//                await PersistenceController.shared.container.performBackgroundTask { context in
//                    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//                    do
//                    {
//                        let result = try context.execute(batchInsert) as! NSBatchInsertResult
//                        print(result)
//                    }
//                    catch
//                    {
//
//                    }
//
//                }
//            }
//            catch {}
//
//
//        }
//    }
//
//    func getDataFromPacket(packet: MarcaDTO) -> Data?
//    {
//        do
//        {
//            let data = try PropertyListEncoder.init().encode(packet)
//            return data
//        }
//        catch let error as NSError
//        {
//            print(error.localizedDescription)
//        }
//        return nil
//    }



//    func loadData() async -> [Datum]
//    {
//        logger.trace("Iniciando fetch")
//
//        await viewModel.getAllMarcas()
//
//        switch viewModel.state
//        {
//        case .loading:
//            logger.trace("Iniciando fetch")
//
//        case .success(let data):
//            for dadosMarca in data.data {
//
//            }
//
//
//        case .failed(let error):
//            logger.trace("Iniciando fetch")
//        case .na:
//            logger.trace("Iniciando fetch")
//        }
//
//        return dados!
//    }
//
//    private func createBatchInsertRequest() async -> NSBatchInsertRequest
//    {
//        var jsonData: [Datum] = await loadData()
//        var itemListIterator = jsonData.makeIterator()
//
//        let batchInsert = NSBatchInsertRequest(entity: Marca.entity()) { (managedObject: NSManagedObject) -> Bool in
//
//                guard let item = itemListIterator.next() else { return true }
//
//                if let marca = managedObject as? Marca
//                {
//                    marca.id = Int16(item.id)
//                    marca.nome = item.name
//                }
//
//                return false
//            }
//        return batchInsert
//    }
//
//    private func batchInsertMarcas(marcas: Marcas) async throws
//    {
//        let container = PersistenceController.shared.container
//        guard !marcas.data.isEmpty else { return }
//
//        await container.performBackgroundTask { publisherContext in
//            do
//            {
//                Task{ let batchInsert =  await self.createBatchInsertRequest()
//                    try publisherContext.execute(batchInsert)}
//            }
//            catch
//            {
//                self.logger.trace("Iniciando fetch")
//            }
//        }
//    }
