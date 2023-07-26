//
//  VeiculoListaDetalheView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 01/07/23.
//

import SwiftUI

struct VeiculoListaDetalheView: View
{
    @ObservedObject var viewModel: VeiculoViewModel
    @State var consulta = false
    
    var veiculo: Veiculo
    
    var body: some View
    {
        HStack
        {
            Label("car", systemImage: "car")
                .labelStyle(.iconOnly)
            
            HStack
            {
                Text(String(veiculo.nome ?? ""))
                Text(String(veiculo.placa ?? ""))
            }
            .onTapGesture {
                consulta = true
            }
            .navigationDestination(isPresented: $consulta, destination: {
                VeiculoReadScreen(viewModel: viewModel, veiculo: veiculo)
            })
        }
    }
}
