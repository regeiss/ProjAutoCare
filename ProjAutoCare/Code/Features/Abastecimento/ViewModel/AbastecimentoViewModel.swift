//
//  AbastecimentoViewModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 24/06/23.
//

import Foundation
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

    func delete(abastecimento: Abastecimento)
    {
        AbastecimentoPublisher.shared.delete(abastecimento: abastecimento)
    }
}