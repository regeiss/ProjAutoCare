//
//  AbastecimentoListaDetalheView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/06/23.
//

import SwiftUI

struct AbastecimentoListaDetalheView: View
{
    var abastecimento: Abastecimento
    
    var body: some View
    {
        HStack
        {
            Label("gas", systemImage: "fuelpump.circle")
                .labelStyle(.iconOnly)
                .imageScale(.large)
            VStack
            {
                HStack
                {
                    Text("Data: ")
                    Text(abastecimento.data!, format: Date.FormatStyle().year().month().day())
                    Spacer()
                }
                
                HStack
                {
                    Text("Total: "); Text(String(format: "%.2f", abastecimento.valorTotal).toCurrencyFormat())
                    Spacer()
                    if abastecimento.media > 0 {
                        Text(String(format: "%.3f", abastecimento.media)); Text(" km/l")}
                }
                HStack
                {
                    Text("Odômetro: ")
                    Text(String(abastecimento.quilometragem).toQuilometrosFormat())
                    Spacer(); Text("Litros: "); Text(String(format: "%.3f", abastecimento.litros))
                }
                HStack{Text(abastecimento.nomePosto); Spacer()}
                // HStack{Text(abastecimento.nomeCarro); Spacer()}
            }
            .padding(.all, 2)
            
        }.padding([.top, .bottom], 2)
            
        
    }
}

extension Abastecimento
{
    @objc
    var nomePosto: String
    {
        self.noPosto?.nome ?? "não informado"
    }
    
    @objc
    var nomeCarro: String
    {
        self.doVeiculo?.nome ?? "não informado"
    }
    
}
