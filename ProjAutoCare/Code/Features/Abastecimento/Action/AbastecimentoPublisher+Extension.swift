//
//  AbastecimentoPublisher+Extension.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 13/08/23.
//

import Foundation
import Combine
import CoreData

extension AbastecimentoPublisher
{
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
        let distanciaPorDia = distancia / Int32(numeroDias)
        
        return distanciaPorDia
    }
}
