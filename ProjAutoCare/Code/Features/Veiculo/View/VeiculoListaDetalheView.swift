//
//  VeiculoListaDetalheView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 01/07/23.
//

import SwiftUI

struct VeiculoListaDetalheView: View
{
    var veiculo: Veiculo
    
    var body: some View
    {
        HStack
        {
            Label("car", systemImage: "car")
                .labelStyle(.iconOnly)
            VStack
            {
                HStack
                {
                    Text(String(veiculo.nome ?? ""))
                    Spacer()
                }
            }
        }
    }
}
