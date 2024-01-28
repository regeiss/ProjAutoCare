//
//  AbastecimentoViewModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 24/06/23.
//

import Combine
import CoreData

class AbastecimentoViewModel: ObservableObject
{
    @Published var abastecimentosLista: [Abastecimento] = []
    
    private var bag: AnyCancellable?
    
    init(abastPublisher: AnyPublisher<[Abastecimento], Never> = AbastecimentoPublisher.shared.abastecimentoCVS.eraseToAnyPublisher())
    {
        bag = abastPublisher.sink { [unowned self] abastecimentosLista in
            self.abastecimentosLista = abastecimentosLista
        }
    }
    
    func add(abastecimento: AbastecimentoDTO)
    {
        AbastecimentoPublisher.shared.add(abastecimento: abastecimento)
    }
    
    func update(abastecimento: Abastecimento)
    {
        AbastecimentoPublisher.shared.update(abastecimento: abastecimento)
    }
    
    func delete(abastecimento: Abastecimento)
    {
        AbastecimentoPublisher.shared.delete(abastecimento: abastecimento)
    }
    
    func fetchByID(abastecimentoID: UUID)
    {
        AbastecimentoPublisher.shared.fetchByID(abastecimentoID: UUID())
    }
    
    func filter(tipo: String)
    {
        AbastecimentoPublisher.shared.filter(tipo: tipo)
    }
    
    func getDistanciaPercorrida() -> Int32
    {
        AbastecimentoPublisher.shared.getDistanciaPercorrida()
    }
    
    func getMelhorConsumo() -> Double
    {
        AbastecimentoPublisher.shared.getMelhorConsumo()
    }
    
    func getPiorConsumo() -> Double
    {
        AbastecimentoPublisher.shared.getPiorConsumo()
    }
    
    func getMediaConsumo() -> Double
    {
        AbastecimentoPublisher.shared.getMediaConsumo()
    }
    
    func getTotalTanques() -> Int
    {
        AbastecimentoPublisher.shared.getTotalTanques()
    }
    
    func getMediaValorLitro() -> Double
    {
        AbastecimentoPublisher.shared.getMediaValorLitro()
    }
    
    func getMediaCustoKM() -> Double
    {
        AbastecimentoPublisher.shared.getMediaCustoKM()
    }
    
    func getCustoPorDia() -> Double 
    {
        AbastecimentoPublisher.shared.getCustoPorDia()
    }
    
    func getKMPorDia() -> Int32
    {
        AbastecimentoPublisher.shared.getKMPorDia()
    }
    
    func calculaMedia(kmAtual: Int32, litros: Double, appState: AppState, primeiraVez: Bool) -> Double
    {
        AbastecimentoPublisher.shared.calculaMedia(kmAtual: kmAtual, litros: litros, appState: appState, primeiraVez: primeiraVez)
    }
}
