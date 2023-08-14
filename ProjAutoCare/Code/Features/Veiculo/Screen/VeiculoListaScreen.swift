//
//  VeiculoListaView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 01/07/23.
//

import SwiftUI

@available(iOS 16.0, *)
struct VeiculoListaScreen: View
{
    @StateObject var viewModel = VeiculoViewModel()
    @State private var adicao = false
    @State private var edicao = false
    
    var body: some View
    {
        VStack
        {
            List
            {
                ForEach(viewModel.veiculosLista, id: \.self) { veiculo in
                    HStack
                    {
                        VeiculoListaDetalheView(viewModel: viewModel, veiculo: veiculo)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("Exluir", systemImage: "trash", role: .destructive, action: { viewModel.delete(veiculo: veiculo)})
                    }
                }
                
                if $viewModel.veiculosLista.isEmpty
                {
                    Text("").listRowBackground(Color.clear)
                }
            }
        }
        .background(Color("backGroundColor"))
        .scrollContentBackground(.hidden)
        .navigationBarTitle("Veículo", displayMode: .automatic)
        .toolbar { ToolbarItem(placement: .navigationBarTrailing)
            { Button {
                adicao = true
            }
                label: { Image(systemName: "plus")}}
        }
        .navigationDestination(isPresented: $adicao, destination: {
            VeiculoAddScreen(viewModel: viewModel)
        })
    }
}
