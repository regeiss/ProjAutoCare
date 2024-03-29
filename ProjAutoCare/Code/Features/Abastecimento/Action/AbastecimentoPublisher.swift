//
//  AbastecimentoAction.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/06/23.
//

import CoreData
import Combine
import OSLog

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
            sectionNameKeyPath: nil, cacheName: nil
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
        novoAbastecimento.quilometragem = abastecimento.quilometragem
        novoAbastecimento.completo = abastecimento.completo
        novoAbastecimento.litros = abastecimento.litros
        novoAbastecimento.data = abastecimento.data
        novoAbastecimento.valorLitro = abastecimento.valorLitro
        novoAbastecimento.valorTotal = (abastecimento.litros * abastecimento.valorLitro)
        novoAbastecimento.media = abastecimento.media
        novoAbastecimento.noPosto = abastecimento.noPosto
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
    
    func fetchByID(abastecimentoID: UUID)
    {
        let fetchRequest: NSFetchRequest<Abastecimento> = Abastecimento.fetchRequest()
        let idPredicate = NSPredicate(format: "id == %@", abastecimentoID as CVarArg)
                                             
        fetchRequest.predicate = idPredicate
        fetchRequest.fetchLimit = 1
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let abastecimentoFilteredFC = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: publisherContext,
            sectionNameKeyPath: nil, cacheName: nil)
        
        abastecimentoFilteredFC.delegate = self
        
        do
        {
            try abastecimentoFilteredFC.performFetch()
            abastecimentoCVS.value = abastecimentoFilteredFC.fetchedObjects ?? []
        }
        catch
        {
            fatalError("Erro moc \(error.localizedDescription)")
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
    
    func filter(tipo: String)
    {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let currentDate = calendar.startOfDay(for: Date())
        
        let fetchRequest: NSFetchRequest<Abastecimento> = Abastecimento.fetchRequest()
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
        
        let abastecimentoFilteredFC = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: publisherContext,
            sectionNameKeyPath: nil, cacheName: nil)
        
        abastecimentoFilteredFC.delegate = self
        
        do
        {
            try abastecimentoFilteredFC.performFetch()
            abastecimentoCVS.value = abastecimentoFilteredFC.fetchedObjects ?? []
        }
        catch
        {
            fatalError("Erro moc \(error.localizedDescription)")
        }
    }
}

extension AbastecimentoPublisher: NSFetchedResultsControllerDelegate
{
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        guard let abastecimentos = controller.fetchedObjects as? [Abastecimento]
        else { return }
        
        self.abastecimentoCVS.value = abastecimentos
    }
}
