//
//  CategoriaPublisher.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 09/07/23.
//

import CoreData
import Combine
import OSLog
import SwiftUI

class CategoriaPublisher: NSObject, ObservableObject
{
    var appState = AppState.shared
    static let shared = CategoriaPublisher()
    var categoriaCVS = CurrentValueSubject<[Categoria], Never>([])
    private let categoriaFetchController: NSFetchedResultsController<Categoria>
    
    var logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Publisher")
    
    var backgroundContext: NSManagedObjectContext = {
         let context = PersistenceController.shared.container.viewContext
             context.mergePolicy = NSMergePolicy( merge: .mergeByPropertyObjectTrumpMergePolicyType)
             context.automaticallyMergesChangesFromParent = true
         return context
         }()
    
    private override init()
    {
        let fetchRequest: NSFetchRequest<Categoria> = Categoria.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: false)

        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.returnsDistinctResults = true

        fetchRequest.propertiesToFetch = ["id", "nome"]
        
        categoriaFetchController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: backgroundContext,
            sectionNameKeyPath: nil, cacheName: nil
        )

        super.init()

        categoriaFetchController.delegate = self

        do
        {
            try categoriaFetchController.performFetch()
            categoriaCVS.value = categoriaFetchController.fetchedObjects ?? []
        }
        catch
        {
            NSLog("Erro: could not fetch objects")
        }
    }

    func add(categoria
             : CategoriaDTO)
    {
        let novaCategoria = Categoria(context: backgroundContext)
        novaCategoria.id = categoria.id
        novaCategoria.nome = categoria.nome
        
        backgroundContext.performAndWait
        {
            do
            {
                try self.backgroundContext.save()
                
            }
            catch
            {
                fatalError("Erro moc \(error.localizedDescription)")
            }
        }
    }

    func update(categoria: Categoria)
    {
        backgroundContext.performAndWait
        {
            do
            {
                try self.backgroundContext.save()
            }
            catch
            {
                fatalError("Erro moc \(error.localizedDescription)")
            }
        }
    }

    func delete(categoria: Categoria)
    {
        backgroundContext.performAndWait
        {
            backgroundContext.delete(categoria
            )
            do
            {
                try self.backgroundContext.save()
            }
            catch
            {
                fatalError("Erro moc \(error.localizedDescription)")
            }
        }
    }

    func inserePadrao()
    {

        let novaCategoria = Categoria(context: backgroundContext)
        novaCategoria.id = UUID()
        novaCategoria.nome = "Nenhum"

        backgroundContext.performAndWait
        {
            do
            {
                try self.backgroundContext.save()
            }
            catch
            {
                fatalError("Erro moc \(error.localizedDescription)")
            }
        }
    }
}

extension CategoriaPublisher: NSFetchedResultsControllerDelegate
{
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        guard let categoria = controller.fetchedObjects as? [Categoria]
        else { return }
        logger.log("Context has changed, reloading categoria")
        self.categoriaCVS.value = categoria
    }
}

