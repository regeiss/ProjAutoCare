//
//  ServicoListaScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 02/07/23.
//

import SwiftUI
import CoreData

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
                }
                .onDelete(perform: deleteServico)
                if viewModel.servicoLista.isEmpty
                {
                    Text("").listRowBackground(Color.clear)
                }
            }
        }
        .background(Color("backGroundColor"))
        .scrollContentBackground(.hidden)
        .navigationBarTitle("Serviço", displayMode: .automatic)
        .toolbar { ToolbarItem(placement: .navigationBarTrailing)
            { Button {
                adicao = true
            }
                label: { Image(systemName: "plus")}}
        }
        .navigationDestination(isPresented: $adicao, destination: {
            ServicoScreen(viewModel: viewModel, servico: Servico(), isEdit: false)
        })
    }
    
    func deleteServico(at offsets: IndexSet)
    {
        for offset in offsets
        {
            let servico = viewModel.servicoLista[offset]
            viewModel.delete(servico: servico)
        }
    }
}
