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
    @StateObject private var viewModel = PostoViewModel()
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
                        PostoListaDetalheView(edicao: $edicao, posto: posto)
                    }
                }
                .onDelete(perform: deletePostos)
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
            PostoScreen(posto: Posto(), isEdit: false)
        })
    }
    
    func deletePostos(at offsets: IndexSet)
    {
        for offset in offsets
        {
            let posto = viewModel.postosLista[offset]
            viewModel.delete(posto: posto)
        }
    }
}
