//
//  MarcaPublisher.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 10/09/23.
//

import Foundation
import CoreData
import OSLog

@MainActor
class MarcasPublisher: NSObject, ObservableObject
{
    var publisherContext: NSManagedObjectContext = {
        let context = PersistenceController.shared.container.viewContext
        context.mergePolicy = NSMergePolicy( merge: .mergeByPropertyObjectTrumpMergePolicyType)
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    var viewModel = MarcaViewModelImpl(service: NetworkService())
    var dados: [Datum]?
    let logger = Logger.init(subsystem: Bundle.main.bundleIdentifier!, category: "main")
    
//    func importaMarcas()
//    {
//        viewModel.getAllMarcas()
//        switch viewModel.state {
//        case .success(let products):
//        self.persistenceController.container.performBackgroundTask { context in
//                  context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//        let batchInsert = NSBatchInsertRequest(entityName: "Product", objects: products)
//        do {
//        let result = try context.execute(batchInsert) as! NSBatchInsertResult
//        print(result)
//                  }
//        catch {
//        let nsError = error as NSError
//        // TODO: handle errors
//                  }
//                  DispatchQueue.main.async {
//                    objectWillChange.send()
//        // TODO: handle errors
//                    try? resultsController.performFetch()
//                  }
//                }
//              }
//            }
//      }
//    
////    
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
}
