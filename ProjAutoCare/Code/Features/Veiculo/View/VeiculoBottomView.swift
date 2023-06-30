//
//  VeiculoBottomView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 17/06/23.
//

import SwiftUI

struct VeiculoBottomView: View
{
    @Environment(\.dismiss) var dismiss
    
    var body: some View
    {
        NavigationView
        {
            VStack(alignment: .leading)
            {
                Text("Veiculo")
            }
            .background(Color("backGroundMain"))
            .scrollContentBackground(.hidden)
            .navigationBarTitle("Selecione um veículo", displayMode: .inline )
            .toolbar(content: {
                ToolbarItem {
                    Button { dismiss()}
                label: { Label("Dismiss", systemImage: "xmark.circle.fill")}
                }
                
            }
            )
        }.presentationDetents([.medium])
    }
}
