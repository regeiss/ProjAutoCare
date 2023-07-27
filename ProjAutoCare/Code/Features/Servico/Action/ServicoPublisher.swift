//
//  ServicoPublisher.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 09/07/23.
//

import CoreData
import Combine
import OSLog

class ServicoPublisher: NSObject, ObservableObject
{
    static let shared = ServicoPublisher()
    var servicoCVS = CurrentValueSubject<[Servico], Never>([])
    private let servicoFetchController: NSFetchedResultsController<Servico>
    var logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Publisher")

    var backgroundContext: NSManagedObjectContext = {
         let context = PersistenceController.shared.container.viewContext
             context.mergePolicy = NSMergePolicy( merge: .mergeByPropertyObjectTrumpMergePolicyType)
             context.automaticallyMergesChangesFromParent = true
         return context
         }()

    private override init()
    {
        let fetchRequest: NSFetchRequest<Servico> = Servico.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: false)

        fetchRequest.sortDescriptors = [sortDescriptor]

        servicoFetchController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: backgroundContext,
            sectionNameKeyPath: nil, cacheName: nil
        )

        super.init()

        servicoFetchController.delegate = self

        do
        {
            try servicoFetchController.performFetch()
            servicoCVS.value = servicoFetchController.fetchedObjects ?? []
        }
        catch
        {
            NSLog("Erro: could not fetch objects")
        }
    }

    func add(servico: ServicoDTO)
    {
        let newServico = Servico(context: backgroundContext)
        newServico.id = servico.id
        // newServico.idperiodicidade = servico.idperiodicidade
        newServico.nome = servico.nome
        // newServico.daCategoria = servico.daCategoria
        
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

    func update(servico: Servico)
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

    func delete(servico: Servico)
    {
        backgroundContext.performAndWait
        {
            backgroundContext.delete(servico)
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

extension ServicoPublisher: NSFetchedResultsControllerDelegate
{
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        guard let servicos = controller.fetchedObjects as? [Servico]
        else { return}
        logger.log("Context has changed, reloading servicos")
        self.servicoCVS.value = servicos
    }
}
