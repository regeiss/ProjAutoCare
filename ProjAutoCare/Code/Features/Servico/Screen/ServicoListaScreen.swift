//
//  ServicoListaScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 02/07/23.
//

import SwiftUI

struct ServicoListaScreen: View
{
    @StateObject var viewModel = ServicoViewModel()
    @State private var adicao = false
    @State private var edicao = false
    
    var body: some View
    {
        VStack
        {
            List
            {
                ForEach(viewModel.servicoLista) { servico in
                    HStack
                    {
                        ServicoListaDetalheView(viewModel: viewModel, servico: servico)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                      Button(role: .destructive, action: { viewModel.delete(servico: servico)})
                        { Label("Delete", systemImage: "trash")}
                    }
                }

                if viewModel.servicoLista.isEmpty
                {
                    Text("").listRowBackground(Color.clear)
                }
            }
        }
        .background(Color("backGroundColor"))
        .scrollContentBackground(.hidden)
        .navigationBarTitle("Serviço", displayMode: .large)
        .toolbar { ToolbarItem(placement: .navigationBarTrailing)
            { Button {
                adicao = true
            }
                label: { Image(systemName: "plus")}}
        }
        .navigationDestination(isPresented: $adicao, destination: {
            ServicoAddScreen(viewModel: viewModel)
        })
    }
}
