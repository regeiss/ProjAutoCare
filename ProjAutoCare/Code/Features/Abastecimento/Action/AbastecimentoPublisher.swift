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
        let novoAbastecimento = Abastecimento(context: publisherContext)
        novoAbastecimento.id = abastecimento.id
        novoAbastecimento.km = abastecimento.quilometragem
        novoAbastecimento.completo = abastecimento.completo
        novoAbastecimento.litros = abastecimento.litros
        novoAbastecimento.data = abastecimento.data
        novoAbastecimento.valorLitro = abastecimento.valorLitro
        novoAbastecimento.valorTotal = (abastecimento.litros * abastecimento.valorLitro)
        novoAbastecimento.media = abastecimento.media
        novoAbastecimento.doPosto = abastecimento.doPosto
        novoAbastecimento.doVeiculo = abastecimento.doVeiculo
        
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
