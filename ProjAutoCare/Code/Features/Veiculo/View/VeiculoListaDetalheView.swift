//
//  VeiculoListaDetalheView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 01/07/23.
//

import SwiftUI

struct VeiculoListaDetalheView: View
{
    @State var edicao = false
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
                edicao = true
            }
            .navigationDestination(isPresented: $edicao, destination: {
                VeiculoScreen(veiculo: veiculo, isEdit: true)
            })
        }
    }
}
