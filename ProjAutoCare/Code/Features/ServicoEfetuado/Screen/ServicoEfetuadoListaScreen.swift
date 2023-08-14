//
//  ServicoEfetuadoListaSCreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 14/07/23.
//

import SwiftUI

struct ServicoEfetuadoListaScreen: View
{
    @StateObject var viewModel = ServicoEfetuadoViewModel()
    @State private var adicao = false
    @State private var edicao = false
    
    var body: some View
    {
        VStack
        {
            List
            {
                ForEach(viewModel.servicoEfetuadoLista) { servicoEfetuado in
                    HStack
                    {
                        ServicoEfetuadoListaDetalheView(viewModel: viewModel, servicoEfetuado: servicoEfetuado)
                    }                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("Exluir", systemImage: "trash", role: .destructive, action: { viewModel.delete(servicoEfetuado: servicoEfetuado)})
                    }
                }
            }
            
            if viewModel.servicoEfetuadoLista.isEmpty
            {
                Text("").listRowBackground(Color.clear)
            }
        }
        .background(Color("backGroundColor"))
        .scrollContentBackground(.hidden)
        .navigationBarTitle("Serviço Efetuado", displayMode: .automatic)
        .toolbar { ToolbarItem(placement: .navigationBarTrailing)
            { Button {
                adicao = true
            }
                label: { Image(systemName: "plus")}}
        }
        .navigationDestination(isPresented: $adicao, destination: {
            ServicoEfetuadoScreen(viewModel: viewModel, servicoEfetuado: ServicoEfetuado(), isEdit: false, isAdd: true)
        })
    }
}
