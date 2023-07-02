//
//  VeiculoViewModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 26/06/23.
//

import Foundation
import Combine
import CoreData

class VeiculoViewModel: ObservableObject
{
    @Published var veiculosLista: [Veiculo] = []

     private var bag: AnyCancellable?

     init(veiculoPublisher: AnyPublisher<[Veiculo], Never> = VeiculoPublisher.shared.veiculoCVS.eraseToAnyPublisher())
     {
         bag = veiculoPublisher.sink { [unowned self] veiculosLista in
             self.veiculosLista = veiculosLista
         }
     }

     func selecionarVeiculoAtivo()
     {
         VeiculoPublisher.shared.selecionarVeiculoAtivo()
     }
     
     func marcarVeiculoAtivo(ativoID: NSManagedObjectID)
     {
         VeiculoPublisher.shared.marcarVeiculoAtivo(ativoID: ativoID)
     }
     
     func update(veiculo: Veiculo)
     {
         VeiculoPublisher.shared.update(veiculo: veiculo)
     }
     
     func add(veiculo: VeiculoDTO)
     {
         VeiculoPublisher.shared.add(veiculo: veiculo)
     }

     func delete(veiculo: Veiculo)
     {
         VeiculoPublisher.shared.delete(veiculo: veiculo)
     }
     
     func inserePadrao()
     {
         VeiculoPublisher.shared.inserePadrao()
     }
 }
