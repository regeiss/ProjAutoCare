//
//  MarcaPublisher.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 10/09/23.
//

import Foundation
import CoreData

class MarcasPublisher: NSObject, ObservableObject
{
    var publisherContext: NSManagedObjectContext = {
        let context = PersistenceController.shared.container.viewContext
        context.mergePolicy = NSMergePolicy( merge: .mergeByPropertyObjectTrumpMergePolicyType)
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    private func newBatchInsertRequest(with marcas: Marcas) -> NSBatchInsertRequest
    {
        var index = 0
        let total = marcas.data.count
        let batchInsert = NSBatchInsertRequest(
            entity: Marca.entity()) { (managedObject: NSManagedObject) -> Bool in
                
                guard index < total else { return true }
                
                if let marca = managedObject as? Marca 
                {
                    let dados = marcas.data[index]
                    marca.id = Int16(dados.id)
                    marca.nome = dados.name
                }
                
                index += 1
                return false
            }
        return batchInsert
    }
    
    private func batchInsertMarcas(marcas: Marcas)
    {
        let container = PersistenceController.shared.container
        guard !marcas.data.isEmpty else { return }
        
        container.performBackgroundTask { publisherContext in
            
            let batchInsert = self.newBatchInsertRequest(with: marcas)
            do
            {
                try publisherContext.execute(batchInsert)
            }
            catch
            {
                
            }
        }
    }
}
