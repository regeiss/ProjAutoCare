//
//  ModeloViewModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 26/09/23.
//

import Combine
import CoreData

class ModeloViewModel: ObservableObject
{
    @Published var modeloLista: [Modelo] = []
    
    private var bag: AnyCancellable?
    
    init(modeloPublisher: AnyPublisher<[Modelo], Never> = ModeloPublisher.shared.modeloCVS.eraseToAnyPublisher())
    {
        bag = modeloPublisher.sink { [unowned self] modelosLista in
            self.modeloLista = modelosLista
        }

        Task { try await  ModeloDecoder.shared.batchDeleteModelos()
               try await  ModeloDecoder.shared.fetchModelos()
               try await  ModeloDecoder.shared.ajustaMarcaModelo()}
    }
}
