//
//  ModeloPublisher.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 26/09/23.
//

import CoreData
import Combine
import OSLog

class ModeloPublisher: NSObject, ObservableObject
{
    static let shared = ModeloPublisher()
    
    var modeloCVS = CurrentValueSubject<[Modelo], Never>([])
    private let modeloFetchController: NSFetchedResultsController<Modelo>
    
    var logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Publisher")
    
    var publisherContext: NSManagedObjectContext = {
        let context = PersistenceController.shared.container.viewContext
        context.mergePolicy = NSMergePolicy( merge: .mergeByPropertyObjectTrumpMergePolicyType)
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    private override init()
    {
        let fetchRequest: NSFetchRequest<Modelo> = Modelo.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.returnsDistinctResults = true
        
        modeloFetchController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: publisherContext,
            sectionNameKeyPath: nil, cacheName: nil
        )
        
        super.init()
        
        modeloFetchController.delegate = self
        
        do
        {
            try modeloFetchController.performFetch()
            modeloCVS.value = modeloFetchController.fetchedObjects ?? []
        }
        catch
        {
            NSLog("Erro: could not fetch objects")
        }
    }
    
}

extension ModeloPublisher: NSFetchedResultsControllerDelegate
{
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        guard let perfis = controller.fetchedObjects as? [Modelo]
        else { return }
        logger.log("Context has changed, reloading postos")
        self.modeloCVS.value = perfis
    }
}
