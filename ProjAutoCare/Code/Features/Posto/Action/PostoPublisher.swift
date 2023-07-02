//
//  PostoPublisher.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 26/06/23.
//

import CoreData
import Combine
import OSLog
import SwiftUI

class PostoPublisher: NSObject, ObservableObject
{
    var appState = AppState.shared
    static let shared = PostoPublisher()
    var postoCVS = CurrentValueSubject<[Posto], Never>([])
    private let postoFetchController: NSFetchedResultsController<Posto>
    
    var logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Publisher")
    
    var backgroundContext: NSManagedObjectContext = {
         let context = PersistenceController.shared.container.viewContext
             context.mergePolicy = NSMergePolicy( merge: .mergeByPropertyObjectTrumpMergePolicyType)
             context.automaticallyMergesChangesFromParent = true
         return context
         }()
    
    private override init()
    {
        let fetchRequest: NSFetchRequest<Posto> = Posto.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: false)

        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.returnsDistinctResults = true

        fetchRequest.propertiesToFetch = ["id", "nome"]
        
        postoFetchController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: backgroundContext,
            sectionNameKeyPath: nil, cacheName: nil
        )

        super.init()

        postoFetchController.delegate = self

        do
        {
            try postoFetchController.performFetch()
            postoCVS.value = postoFetchController.fetchedObjects ?? []
        }
        catch
        {
            NSLog("Erro: could not fetch objects")
        }
    }

    func add(posto: PostoDTO)
    {
        let newPosto = Posto(context: backgroundContext)
        newPosto.id = posto.id
        newPosto.nome = posto.nome
        newPosto.bandeira = posto.bandeira
        
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

    func update(posto: Posto)
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

    func delete(posto: Posto)
    {
        backgroundContext.performAndWait
        {
            backgroundContext.delete(posto)
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

        let newPosto = Posto(context: backgroundContext)
        newPosto.id = UUID()
        newPosto.nome = "Nenhum"
        newPosto.bandeira = "Nenhum"
        newPosto.padrao = true
        
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

       appState.postoPadrao = newPosto
    }

    func selecionarPostoPadrao()
    {
        let fetchRequest: NSFetchRequest<Posto> = Posto.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(padrao == 1)")
        fetchRequest.fetchLimit = 1

        do
        {
            logger.log("Context has changed, buscando posto padrao")
            guard let postoPadrao = try backgroundContext.fetch(fetchRequest).first
            else { return }
            appState.postoPadrao = postoPadrao
        }
        catch
        {
            fatalError("Erro moc \(error.localizedDescription)")
        }
    }
}

extension PostoPublisher: NSFetchedResultsControllerDelegate
{
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        guard let postos = controller.fetchedObjects as? [Posto]
        else { return }
        logger.log("Context has changed, reloading postos")
        self.postoCVS.value = postos
    }
}
