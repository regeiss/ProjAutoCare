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
    @StateObject private var viewModel = PerfilViewModel()
    @State private var adicao = false
    
    var body: some View
    {
        VStack
        {
            List
            {
                ForEach(viewModel.perfilLista, id: \.self) { perfil in
                    HStack
                    {
                        PerfilListaDetalheView(perfil: perfil)
                    }
                }.onDelete(perform: deletePerfil)
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
            PerfilScreen(perfil: Perfil(), isEdit: false)
        })
    }
    
    func deletePerfil(at offsets: IndexSet)
    {
        for offset in offsets
        {
            let perfil = viewModel.perfilLista[offset]
            viewModel.delete(perfil: perfil)
        }
    }
}
