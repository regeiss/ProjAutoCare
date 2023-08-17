//
//  RegistroPublisher.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 15/08/23.
//

import CoreData
import Combine
import OSLog

class RegistroPublisher: NSObject, ObservableObject
{
    var appState = AppState.shared
    static let shared = RegistroPublisher()
    var registroCVS = CurrentValueSubject<[Registro], Never>([])
    private let registroFetchController: NSFetchedResultsController<Registro>
    
    var logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Publisher")
    
    var backgroundContext: NSManagedObjectContext = {
         let context = PersistenceController.shared.container.viewContext
             context.mergePolicy = NSMergePolicy( merge: .mergeByPropertyObjectTrumpMergePolicyType)
             context.automaticallyMergesChangesFromParent = true
         return context
         }()
    
    private override init()
    {
        let fetchRequest: NSFetchRequest<Registro> = Registro.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "data", ascending: false)

        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.returnsDistinctResults = true

        registroFetchController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: backgroundContext,
            sectionNameKeyPath: nil, cacheName: nil
        )

        super.init()

        registroFetchController.delegate = self

        do
        {
            try registroFetchController.performFetch()
            registroCVS.value = registroFetchController.fetchedObjects ?? []
        }
        catch
        {
            NSLog("Erro: could not fetch objects")
        }
    }

    func add(registro: RegistroDTO)
    {
        let novoRegistro = Registro(context: backgroundContext)
        novoRegistro.id = registro.id
        novoRegistro.data = registro.data
        novoRegistro.tipo = registro.tipo
        novoRegistro.idTipo = registro.idTipo
        
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

    func update(registro: Registro)
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

    func delete(registro: Registro)
    {
        backgroundContext.performAndWait
        {
            backgroundContext.delete(registro
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
}

extension RegistroPublisher: NSFetchedResultsControllerDelegate
{
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        guard let registro = controller.fetchedObjects as? [Registro]
        else { return }
        logger.log("Context has changed, reloading categoria")
        self.registroCVS.value = registro
    }
}
