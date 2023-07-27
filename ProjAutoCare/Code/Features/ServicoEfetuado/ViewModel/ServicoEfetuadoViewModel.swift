//
//  ServicoEfetuadoViewModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 14/07/23.
//

import Combine
import CoreData

class ServicoEfetuadoViewModel: ObservableObject
{
    @Published var servicoEfetuadoLista: [ServicoEfetuado] = []

    private var bag: AnyCancellable?

    init(servicoEfetuadoPublisher: AnyPublisher<[ServicoEfetuado], Never> = ServicoEfetuadoPublisher.shared.servicoEfetuadoCVS.eraseToAnyPublisher())
    {
        bag = servicoEfetuadoPublisher.sink { [unowned self] servicoEfetuadoLista in
            self.servicoEfetuadoLista = servicoEfetuadoLista
        }
        
    }

    func add(servicoEfetuado: ServicoEfetuadoDTO)
    {
        ServicoEfetuadoPublisher.shared.add(servicoEfetuado: servicoEfetuado)
    }

    func delete(servicoEfetuado: ServicoEfetuado)
    {
        ServicoEfetuadoPublisher.shared.delete(servicoEfetuado: servicoEfetuado)
    }

    func update(servicoEfetuado: ServicoEfetuado)
    {
        ServicoEfetuadoPublisher.shared.update(itemServico: servicoEfetuado)
    }
    
    func filter(tipo: String)
    {
        ServicoEfetuadoPublisher.shared.filter(tipo: tipo)
    }
}
