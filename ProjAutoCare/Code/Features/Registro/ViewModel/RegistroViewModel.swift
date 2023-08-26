//
//  RegistroViewModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 16/08/23.
//

import Combine
import CoreData

class RegistroViewModel: ObservableObject
{
    @Published var registrosLista: [Registro] = []
    
    private var bag: AnyCancellable?
    
    init(registroPublisher: AnyPublisher<[Registro], Never> = RegistroPublisher.shared.registroCVS.eraseToAnyPublisher())
    {
        bag = registroPublisher.sink { [unowned self] registrosLista in
            self.registrosLista = registrosLista
        }
    }
    
    func add(registro: RegistroDTO)
    {
        RegistroPublisher.shared.add(registro: registro)
    }
    
    func delete(registro: Registro)
    {
        RegistroPublisher.shared.delete(registro: registro)
    }
    
    func buscaRegistroAbastecimento(id: UUID) -> Abastecimento
    {
        RegistroPublisher.shared.buscaRegistroAbastecimento(id: id)
    }
    
    func buscaRegistroServico(id: UUID) -> ServicoEfetuado
    {
        RegistroPublisher.shared.buscaRegistroServico(id: id)
    }
}
