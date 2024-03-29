//
//  PerfilListaScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 02/07/23.
//

import SwiftUI

@available(iOS 16.0, *)
struct PerfilListaScreen: View
{
    @StateObject var viewModel = PerfilViewModel()
    @State private var adicao = false
    
    var body: some View
    {
        VStack
        {
            List
            {
                ForEach(viewModel.perfilLista) { perfil in
                    HStack
                    {
                        PerfilListaDetalheView(viewModel: viewModel, perfil: perfil)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("Exluir", role: .destructive, action: { viewModel.delete(perfil: perfil)})
                        
                    }
                }
                if viewModel.perfilLista.isEmpty
                {
                    Text("").listRowBackground(Color.clear)
                }
            }
        }
        .background(Color("backGroundColor"))
        .scrollContentBackground(.hidden)
        .navigationBarTitle("Perfis", displayMode: .automatic)
        .toolbar { ToolbarItem(placement: .navigationBarTrailing)
            { Button {
                adicao = true
            }
                label: { Image(systemName: "plus")}}
        }
        .navigationDestination(isPresented: $adicao, destination: {
            PerfilAddScreen(viewModel: viewModel)
        })
    }
}
