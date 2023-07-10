//
//  CategoriaViewModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 09/07/23.
//

import Foundation

import Foundation
import CoreData
import Combine

class CategoriaViewModel: ObservableObject
{
    @Published var categoriaLista: [Categoria] = []

    private var bag: AnyCancellable?

    init(categoriaPublisher: AnyPublisher<[Categoria], Never> = CategoriaPublisher.shared.categoriaCVS.eraseToAnyPublisher())
    {
        bag = categoriaPublisher.sink { [unowned self] categoriaLista in
            self.categoriaLista = categoriaLista
        }
    }

    
    func add(categoria: CategoriaDTO)
    {
        CategoriaPublisher.shared.add(categoria: categoria)
    }

    func update(categoria: Categoria)
    {
        CategoriaPublisher.shared.update(categoria: categoria)
    }
    
    func delete(categoria: Categoria)
    {
        CategoriaPublisher.shared.delete(categoria: categoria)
    }
}
