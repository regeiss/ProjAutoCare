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
        @State var edicao: Bool = false
        var categoria: Categoria
        
        var body: some View
        {
            HStack
            {
                Text(categoria.nome ?? "")
            }
            .onTapGesture {
                edicao = true
            }
            .navigationDestination(isPresented: $edicao, destination: {
                CategoriaScreen(viewModel: viewModel, categoria: categoria, isEdit: true)
            })
        }
    }
