//
//  RegistroListaDetalheView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 16/08/23.
//

import SwiftUI

struct RegistroListaDetalheView: View
{
    var registro: Registro
    
    var body: some View
    {
        HStack
        {
            if registro.tipo == "AB"
            {
                Label("gas", systemImage: "fuelpump.circle")
                    .labelStyle(.iconOnly)
                    .imageScale(.large)
            }
            else
            {
                Label("gas", systemImage: "wrench.and.screwdriver")
                    .labelStyle(.iconOnly)
                    .imageScale(.large)
            }
            
            VStack
            {
                HStack
                {
                    Text("Data: ")
                    Text(registro.data!, format: Date.FormatStyle().year().month().day())
                    Spacer()
                }
                
                HStack
                {
                    Text("Total: ") // ; Text(String(format: "%.2f", registro.valorTotal).toCurrencyFormat())
                    //                    Spacer()
                    //                    if registro.media > 0 {
                    //                        Text(String(format: "%.3f", registro.media)); Text(" km/l")}
                }
                
                HStack
                {
                    Text("Odômetro: ")
                    //                    Text(String(registro.quilometragem).toQuilometrosFormat())
                    //                    Spacer(); Text("Litros: "); Text(String(format: "%.3f", registro.litros))
                }
                
                HStack{Text(registro.tipo!); Spacer()}
                // HStack{Text(abastecimento.nomeCarro); Spacer()}
            }
            // .padding(.all, 2)
        }
    }
}
