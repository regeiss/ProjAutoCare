//
//  CategoriaListaDetalheView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 09/07/23.
//

import SwiftUI

    @available(iOS 16.0, *)
    struct CategoriaListaDetalheView: View
    {
        @ObservedObject var viewModel: CategoriaViewModel
        @State var consulta: Bool = false
        var categoria: Categoria
        
        var body: some View
        {
            HStack
            {
                Text(categoria.nome ?? "")
            }
            .onTapGesture {
                consulta = true
            }
            .navigationDestination(isPresented: $consulta, destination: {
                CategoriaReadScreen(viewModel: viewModel, categoria: categoria)
            })
        }
    }
