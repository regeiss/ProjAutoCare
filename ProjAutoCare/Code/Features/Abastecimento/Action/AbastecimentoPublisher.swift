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
        
        // TODO: verificar quebras de secao
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
    
    func getDistanciaPercorrida() -> Int32
    {
        var kmPercorrida: Int32 = 0
        let fetchRequest: NSFetchRequest<Abastecimento> = Abastecimento.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "quilometragem", ascending: true)
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
            
            let kmInicial = abastecimentoCVS.value.first?.quilometragem  ?? 0
            let kmFinal = abastecimentoCVS.value.last?.quilometragem  ?? 0
            kmPercorrida = kmFinal - kmInicial
        }
        catch
        {
            fatalError("Erro moc \(error.localizedDescription)")
        }
        
        return kmPercorrida
    }
    
    func getMediaConsumo() -> Double
    {
        let fetchRequest: NSFetchRequest<Abastecimento> = Abastecimento.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "media", ascending: true)
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
        
        var mediaConsumo: Double {
            abastecimentoCVS.value.map { Double($0.media)}.reduce(0, +) / Double(abastecimentoCVS.value.count)
        }
        
        return mediaConsumo
    }
    
    func getMelhorConsumo() -> Double
    {
        var melhorConsumo: Double = 0
        let fetchRequest: NSFetchRequest<Abastecimento> = Abastecimento.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "media", ascending: true)
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
        
        melhorConsumo = abastecimentoCVS.value.last?.media ?? 0
        
        return melhorConsumo
    }
    
    func getPiorConsumo() -> Double
    {
        var piorConsumo: Double = 0
        let fetchRequest: NSFetchRequest<Abastecimento> = Abastecimento.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "media", ascending: true)
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
        
        piorConsumo = abastecimentoCVS.value.first?.media ?? 0
        
        return piorConsumo
    }
    
    func getTotalTanques() -> Int
    {
        let fetchRequest: NSFetchRequest<Abastecimento> = Abastecimento.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let completoPredicate = NSPredicate(format: "(completo == true)")
        fetchRequest.predicate = completoPredicate
        
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
        
        return Int(abastecimentoCVS.value.count)
    }

    func getMediaValorLitro() -> Double
    {
        let fetchRequest: NSFetchRequest<Abastecimento> = Abastecimento.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
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
        
        var mediaCustoLitro: Double {
            abastecimentoCVS.value.map { Double($0.valorLitro)}.reduce(0, +) / Double(abastecimentoCVS.value.count)
        }
        print(mediaCustoLitro)
        return mediaCustoLitro
    }
    
    func getMediaCustoKM() -> Double
    {
        let consumoMedio = getMediaConsumo()
        let mediaValorLitro = getMediaValorLitro()
        
        let media = 1 / consumoMedio
        let mediaCusto = media * mediaValorLitro
        
        return mediaCusto
    }
    
    func getCustoPorDia() -> Double
    {
        var calendar = Calendar(identifier: .gregorian)
        let timezone = TimeZone(secondsFromGMT: 0)!
        calendar.timeZone = timezone
        
        var primeiraData: Date = Date()
        let fetchRequest: NSFetchRequest<Abastecimento> = Abastecimento.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "media", ascending: true)
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
        
        primeiraData = abastecimentoCVS.value.first?.data ?? Date()
        
        let numeroDias = calendar.numberOfDaysBetween(primeiraData, and: Date())
        let distancia = getDistanciaPercorrida()
        let custoKM = getMediaCustoKM()
        let distanciaPorDia = distancia / Int32(numeroDias)
        let custoPorDia = Double(distanciaPorDia) * custoKM
        
        return custoPorDia
    }
    
    func getKMPorDia() -> Int32
    {
        var calendar = Calendar(identifier: .gregorian)
        let timezone = TimeZone(secondsFromGMT: 0)!
        calendar.timeZone = timezone
        
        var primeiraData: Date = Date()
        let fetchRequest: NSFetchRequest<Abastecimento> = Abastecimento.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "media", ascending: true)
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
        
        primeiraData = abastecimentoCVS.value.first?.data ?? Date()
        
        let numeroDias = calendar.numberOfDaysBetween(primeiraData, and: Date())
        let distancia = getDistanciaPercorrida()
        let custoKM = getMediaCustoKM()
        let distanciaPorDia = distancia / Int32(numeroDias)
        
        return distanciaPorDia
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
