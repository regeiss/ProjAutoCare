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
