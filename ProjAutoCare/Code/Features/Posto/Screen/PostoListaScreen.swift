//
//  PostoListaScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 29/06/23.
//

import SwiftUI

@available(iOS 16.0, *)
struct PostoListaScreen: View
{
    @StateObject var viewModel = PostoViewModel()
    @State private var adicao = false
    @State private var edicao = false
    
    var body: some View
    {
        VStack
        {
            List
            {
                ForEach(viewModel.postosLista) { posto in
                    HStack
                    {
                        PostoListaDetalheView(viewModel: viewModel, posto: posto)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("Exluir", systemImage: "trash", role: .destructive, action: { viewModel.delete(posto: posto)})
                    }
                }
                
                if viewModel.postosLista.isEmpty
                {
                    Text("").listRowBackground(Color.clear)
                }
            }
        }
        .background(Color("backGroundColor"))
        .scrollContentBackground(.hidden)
        .navigationBarTitle("Postos", displayMode: .automatic)
        .toolbar { ToolbarItem(placement: .navigationBarTrailing)
            { Button {
                adicao = true
            }
                label: { Image(systemName: "plus")}}
        }
        .navigationDestination(isPresented: $adicao, destination: {
            PostoAddScreen(viewModel: viewModel)
        })
    }
}
