//
//  CategoriaListaScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 02/07/23.
//

import SwiftUI
import CoreData
import Combine

@available(iOS 16.0, *)
struct CategoriaListaScreen: View
{
    @StateObject var viewModel = CategoriaViewModel()
    @State private var adicao = false
    
    
    var body: some View
    {
        VStack
        {
            List
            {
                ForEach(viewModel.categoriaLista) { categoria in
                    HStack
                    {
                        CategoriaListaDetalheView(viewModel: viewModel, categoria: categoria)
                    }
                }
                .onDelete(perform: deleteCategoria)
                if viewModel.categoriaLista.isEmpty
                {
                    Text("").listRowBackground(Color.clear)
                }
            }
        }
        .background(Color("backGroundColor"))
        .scrollContentBackground(.hidden)
        .navigationBarTitle("Categoria", displayMode: .automatic)
        .toolbar { ToolbarItem(placement: .navigationBarTrailing)
            { Button {
                adicao = true
            }
                label: { Image(systemName: "plus")}}
        }
        .navigationDestination(isPresented: $adicao, destination: {
            CategoriaAddScreen(viewModel: viewModel, categoria: Categoria())
        })
    }
    
    func deleteCategoria(at offsets: IndexSet)
    {
        for offset in offsets
        {
            let categoria = viewModel.categoriaLista[offset]
            viewModel.delete(categoria: categoria)
        }
    }
}
