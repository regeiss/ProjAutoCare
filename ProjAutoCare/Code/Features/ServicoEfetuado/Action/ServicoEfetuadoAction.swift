//
//  ItemServicoAction.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 13/07/23.
//

import CoreData
import Combine
import OSLog
import SwiftUI

class ServicoEfetuadoPublisher: NSObject, ObservableObject
{
    static let shared = ServicoEfetuadoPublisher()
    var servicoEfetuadoCVS = CurrentValueSubject<[ServicoEfetuado], Never>([])
    private let servicoEfetuadoFetchController: NSFetchedResultsController<ServicoEfetuado>
    var logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Publisher")

    var backgroundContext: NSManagedObjectContext = {
         let context = PersistenceController.shared.container.viewContext
             context.mergePolicy = NSMergePolicy( merge: .mergeByPropertyObjectTrumpMergePolicyType)
             context.automaticallyMergesChangesFromParent = true
         return context
         }()

    private override init()
    {
        let fetchRequest: NSFetchRequest<ServicoEfetuado> = ServicoEfetuado.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "data", ascending: false)

        fetchRequest.sortDescriptors = [sortDescriptor]

        servicoEfetuadoFetchController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: backgroundContext,
            sectionNameKeyPath: nil, cacheName: nil
        )

        super.init()

        servicoEfetuadoFetchController.delegate = self

        do
        {
            try servicoEfetuadoFetchController.performFetch()
            servicoEfetuadoCVS.value = servicoEfetuadoFetchController.fetchedObjects ?? []
        }
        catch
        {
            NSLog("Erro: could not fetch objects")
        }
    }

    func add(servicoEfetuado: ServicoEfetuadoDTO)
    {
        let novoServicoEfetuado = ServicoEfetuado(context: backgroundContext)
        novoServicoEfetuado.id = servicoEfetuado.id
        novoServicoEfetuado.quilometragem = servicoEfetuado.quilometragem
        novoServicoEfetuado.data = servicoEfetuado.data
        novoServicoEfetuado.custo = servicoEfetuado.custo
        novoServicoEfetuado.nome = servicoEfetuado.nome
        novoServicoEfetuado.observacoes = servicoEfetuado.observacoes
        novoServicoEfetuado.doServico = servicoEfetuado.doServico
        
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

    func update(itemServico: ServicoEfetuado)
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
    // MARK: Filtro de registro
    func filter(tipo: String)
    {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let currentDate = calendar.startOfDay(for: Date())

        let fetchRequest: NSFetchRequest<ServicoEfetuado> = ServicoEfetuado.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "data", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if tipo == "Últimos 15 dias"
        {
            let ultimos15Dias = calendar.date(byAdding: .day, value: -15, to: currentDate)
            let ultimos15DiasPredicate = NSPredicate(format: "(data >= %@) AND (data <= %@)", ultimos15Dias! as NSDate, Date() as NSDate)
            fetchRequest.predicate = ultimos15DiasPredicate
        }
        else if tipo == "Últimos 30 dias"
        {
            let ultimos30Dias = calendar.date(byAdding: .day, value: -30, to: currentDate)
            let ultimos30DiasPredicate = NSPredicate(format: "(data >= %@) AND (data <= %@)", ultimos30Dias! as NSDate, Date() as NSDate)
            fetchRequest.predicate = ultimos30DiasPredicate
        }
        else if tipo == "Mês atual"
        {
            print(Date().startOfMonth)
            print(Date().endOfMonth)
            let inicioMesAtual = Date().startOfMonth
            let finalMesAtual = Date().endOfMonth
            let mesAtualPredicate = NSPredicate(format: "(data >= %@) AND (data < %@)", inicioMesAtual as NSDate, finalMesAtual as NSDate)
            fetchRequest.predicate = mesAtualPredicate
        }
        
        // Verificar quebras de secao
        let servicoEfetuadoFC = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: backgroundContext,
            sectionNameKeyPath: nil, cacheName: nil)
        
        servicoEfetuadoFC.delegate = self
        
        do
        {
            logger.log("Context has changed - filter, reloading servicos")
            try servicoEfetuadoFC.performFetch()
            servicoEfetuadoCVS.value = servicoEfetuadoFC.fetchedObjects ?? []
        }
        catch
        {
            fatalError("Erro moc \(error.localizedDescription)")
        }

    }
    
    func delete(servicoEfetuado: ServicoEfetuado)
    {
        backgroundContext.performAndWait
        {
            backgroundContext.delete(servicoEfetuado)
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

extension ServicoEfetuadoPublisher: NSFetchedResultsControllerDelegate
{
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        guard let servicoEfetuado = controller.fetchedObjects as? [ServicoEfetuado]
        else { return}
        logger.log("Context has changed, reloading servicos")
        self.servicoEfetuadoCVS.value = servicoEfetuado
    }
}
