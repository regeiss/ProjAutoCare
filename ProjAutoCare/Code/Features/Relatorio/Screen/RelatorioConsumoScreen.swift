//
//  RelatorioConsumoScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 30/07/23.
//

import SwiftUI

struct RelatorioConsumoScreen: View
{
    private var consumoMedio: Double = 0
    private var piorConsumo: Double = 0
    private var melhorConsumo: Double = 0
    private var distanciaTotal: Double = 0

    var body: some View
    {
        VStack
        {
            Form
            {
                HStack
                {
                    Text("Consumo médio")
                    Spacer()
                    Text(String(consumoMedio))
                }
                HStack
                {
                    Text("Pior consumo ")
                    Spacer()
                    Text(String(consumoMedio))
                }
                HStack
                {
                    Text("Melhor consumo ")
                    Spacer()
                    Text(String(consumoMedio))
                }
                HStack
                {
                    Text("Distância total ")
                    Spacer()
                    Text(String(consumoMedio))
                }
            }
            .padding([.leading, .trailing], 5)
            .scrollContentBackground(.hidden)
        }
        .background(Color("backGroundColor"))
        .navigationTitle("Consumo")
        .navigationBarTitleDisplayMode(.large)
    }
}
