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
    @StateObject private var viewModel = VeiculoViewModel()
    @State private var adicao = false
    
    var body: some View
    {
        VStack
        {
            List
            {
                ForEach(viewModel.veiculosLista, id: \.self) { veiculo in
                    HStack
                    {
                        VeiculoListaDetalheView(veiculo: veiculo)
                    }
                    
                }.onDelete(perform: deleteVeiculos)
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
            VeiculoScreen(veiculo: Veiculo(), isEdit: false)
        })
    }
    
    func deleteVeiculos(at offsets: IndexSet)
    {
        for offset in offsets
        {
            let veiculo = viewModel.veiculosLista[offset]
            viewModel.delete(veiculo: veiculo)
        }
    }
}
