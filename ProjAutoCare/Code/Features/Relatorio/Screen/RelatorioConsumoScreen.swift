//
//  RelatorioConsumoScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 30/07/23.
//

import SwiftUI

struct RelatorioConsumoScreen: View
{
    @StateObject private var viewModel = AbastecimentoViewModel()
    
    @State private var mediaConsumo: Double = 0
    @State private var piorConsumo: Double = 0
    @State private var melhorConsumo: Double = 0
    @State private var distanciaTotal: Int32 = 0

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
                    Text(String(mediaConsumo).toMediaConsumoFormat())
                }
                HStack
                {
                    Text("Pior consumo ")
                    Spacer()
                    Text(String(piorConsumo).toMediaConsumoFormat())
                }
                HStack
                {
                    Text("Melhor consumo ")
                    Spacer()
                    Text(String(melhorConsumo).toMediaConsumoFormat())
                }
                HStack
                {
                    Text("Distância total ")
                    Spacer()
                    Text(String(distanciaTotal).toQuilometrosFormat())
                }
            }
            .padding([.leading, .trailing], 5)
            .scrollContentBackground(.hidden)
        }
        .background(Color("backGroundColor"))
        .navigationTitle("Consumo")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            distanciaTotal = viewModel.getDistanciaPercorrida()
            melhorConsumo = viewModel.getMelhorConsumo()
            mediaConsumo = viewModel.getMediaConsumo()
            piorConsumo = viewModel.getPiorConsumo()
        }
    }
}
