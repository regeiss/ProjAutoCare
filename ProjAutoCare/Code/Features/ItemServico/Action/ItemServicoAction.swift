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

class ItemServicoPublisher: NSObject, ObservableObject
{
    static let shared = ItemServicoPublisher()
    var itemServicoCVS = CurrentValueSubject<[ItemServico], Never>([])
    private let itemServicoFetchController: NSFetchedResultsController<ItemServico>
    var logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Publisher")

    var backgroundContext: NSManagedObjectContext = {
         let context = PersistenceController.shared.container.viewContext
             context.mergePolicy = NSMergePolicy( merge: .mergeByPropertyObjectTrumpMergePolicyType)
             context.automaticallyMergesChangesFromParent = true
         return context
         }()

    private override init()
    {
        let fetchRequest: NSFetchRequest<ItemServico> = ItemServico.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "data", ascending: false)

        fetchRequest.sortDescriptors = [sortDescriptor]

        itemServicoFetchController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: backgroundContext,
            sectionNameKeyPath: nil, cacheName: nil
        )

        super.init()

        itemServicoFetchController.delegate = self

        do
        {
            try itemServicoFetchController.performFetch()
            itemServicoCVS.value = itemServicoFetchController.fetchedObjects ?? []
        }
        catch
        {
            NSLog("Erro: could not fetch objects")
        }
    }

    func add(itemServico: NovoItemServico)
    {
        let newItemServico = ItemServico(context: backgroundContext)
        newItemServico.id = itemServico.id
        newItemServico.km = itemServico.km
        newItemServico.data = itemServico.data
        newItemServico.custo = itemServico.custo
        newItemServico.nome = itemServico.nome
        newItemServico.observacoes = itemServico.observacoes
        newItemServico.doServico = itemServico.doServico
        
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

    func update(itemServico: ItemServico)
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

        let fetchRequest: NSFetchRequest<ItemServico> = ItemServico.fetchRequest()
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
            print(Date().startOfMonth)     // "2018-02-01 08:00:00 +0000\n"
            print(Date().endOfMonth)
            let inicioMesAtual = Date().startOfMonth
            let finalMesAtual = Date().endOfMonth
            let mesAtualPredicate = NSPredicate(format: "(data >= %@) AND (data < %@)", inicioMesAtual as NSDate, finalMesAtual as NSDate)
            fetchRequest.predicate = mesAtualPredicate
        }
        
        // TODO: verificar quebras de secao
        let itemServicoFilteredFC = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: backgroundContext,
            sectionNameKeyPath: nil, cacheName: nil)
        
        itemServicoFilteredFC.delegate = self
        
        do
        {
            logger.log("Context has changed - filter, reloading servicos")
            try itemServicoFilteredFC.performFetch()
            itemServicoCVS.value = itemServicoFilteredFC.fetchedObjects ?? []
        }
        catch
        {
            fatalError("Erro moc \(error.localizedDescription)")
        }

    }
    
    func delete(itemServico: ItemServico)
    {
        backgroundContext.performAndWait
        {
            backgroundContext.delete(itemServico)
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

extension ItemServicoPublisher: NSFetchedResultsControllerDelegate
{
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        guard let servicos = controller.fetchedObjects as? [ItemServico]
        else { return}
        logger.log("Context has changed, reloading servicos")
        self.itemServicoCVS.value = servicos
    }
}



