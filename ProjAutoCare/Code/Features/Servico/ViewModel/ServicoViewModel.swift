//
//  ServicoViewModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 09/07/23.
//

import Combine

class ServicoViewModel: ObservableObject
{
    @Published var servicoLista: [Servico] = []

    private var bag: AnyCancellable?

    init(servicoPublisher: AnyPublisher<[Servico], Never> = ServicoPublisher.shared.servicoCVS.eraseToAnyPublisher())
    {
        bag = servicoPublisher.sink { [unowned self] servicoLista in
            self.servicoLista = servicoLista
        }
    }

    func inserePadrao()
    {
        ServicoPublisher.shared.inserePadrao()
    }
    
    func add(servico: ServicoDTO)
    {
        ServicoPublisher.shared.add(servico: servico)
    }

    func update(servico: Servico)
    {
        ServicoPublisher.shared.update(servico: servico)
    }
    
    func delete(servico: Servico)
    {
        ServicoPublisher.shared.delete(servico: servico)
    }
}
