//
//  MarcaViewModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 07/09/23.
//

import Combine
import CoreData

class MarcaViewModel: ObservableObject
{
    @Published var marcaLista: [Marca] = []

    private var bag: AnyCancellable?

    init(marcaPublisher: AnyPublisher<[Marca], Never> = MarcaPublisher.shared.marcaCVS.eraseToAnyPublisher())
    {
        bag = marcaPublisher.sink { [unowned self] marcasLista in
            self.marcaLista = marcasLista
        }
       
        MarcaDecoder.shared.batchDeleteMarcas()
        Task { try await MarcaDecoder.shared.fetchMarcas()}
    }
}
