//
//  AbastecimentoAction.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/06/23.
//

import Foundation
import CoreData
import Combine
import OSLog
import SwiftUI

class AbastecimentoPublisher: NSObject, ObservableObject
{
    static let shared = AbastecimentoPublisher()
    var abastecimentoCVS = CurrentValueSubject<[Abastecimento], Never>([])
    private let abastecimentoFetchController: NSFetchedResultsController<Abastecimento>
    var logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Publisher")
    
    var publisherContext: NSManagedObjectContext = {
         let context = PersistenceController.shared.container.viewContext
             context.mergePolicy = NSMergePolicy( merge: .mergeByPropertyObjectTrumpMergePolicyType)
             context.automaticallyMergesChangesFromParent = true
         return context
         }()
    
    private override init()
    {
        let fetchRequest: NSFetchRequest<Abastecimento> = Abastecimento.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "data", ascending: false)

        fetchRequest.sortDescriptors = [sortDescriptor]

        abastecimentoFetchController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: publisherContext,
            sectionNameKeyPath: #keyPath(Abastecimento.data), cacheName: nil
        )

        super.init()

        abastecimentoFetchController.delegate = self

        do
        {
            try abastecimentoFetchController.performFetch()
            abastecimentoCVS.value = abastecimentoFetchController.fetchedObjects ?? []
        }
        catch
        {
            NSLog("Erro: could not fetch objects")
        }
    }

    func add(abastecimento: AbastecimentoDTO)
    {
        let newAbastecimento = Abastecimento(context: publisherContext)
        newAbastecimento.id = abastecimento.id
        newAbastecimento.km = abastecimento.km
        newAbastecimento.completo = abastecimento.completo
        newAbastecimento.litros = abastecimento.litros
        newAbastecimento.data = abastecimento.data
        newAbastecimento.valorLitro = abastecimento.valorLitro
        newAbastecimento.valorTotal = Decimal(abastecimento.litros * abastecimento.valorLitro) as NSDecimalNumber
        newAbastecimento.media = abastecimento.media
//        newAbastecimento.doPosto = abastecimento.doPosto
//        newAbastecimento.doCarro = abastecimento.doCarro
        
        publisherContext.performAndWait
        {
            do
            {
                try self.publisherContext.save()
            }
            catch
            {
                fatalError("Erro moc \(error.localizedDescription)")
            }
        }
    }

    func update(abastecimento: Abastecimento)
    {
        publisherContext.performAndWait
        {
            do
            {
                try self.publisherContext.save()
            }
            catch
            {
                fatalError("Erro moc \(error.localizedDescription)")
            }
        }
    }

    func delete(abastecimento: Abastecimento)
    {
        publisherContext.performAndWait
        {
            publisherContext.delete(abastecimento)
            do
            {
                try self.publisherContext.save()
            }
            catch
            {
                fatalError("Erro moc \(error.localizedDescription)")
            }
        }
    }
}

extension AbastecimentoPublisher: NSFetchedResultsControllerDelegate
{
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        guard let abastecimentos = controller.fetchedObjects as? [Abastecimento]
        else { return }
        logger.log("Context has changed, reloading abastecimento")
        
        self.abastecimentoCVS.value = abastecimentos
    }
}

extension Date
{
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents
    {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int
    {
        return calendar.component(component, from: self)
    }
}
