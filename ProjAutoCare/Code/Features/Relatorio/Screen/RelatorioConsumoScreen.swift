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
    @State private var totalTanques: Int = 0
    @State private var mediaCustoKM: Double = 0
    @State private var mediaCustoLitro: Double = 0
    @State private var custoDia: Double = 0
    @State private var kmDia: Double = 0
    @State private var custoKM: Double = 0
    
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
                HStack
                {
                    Text("Nro de tanques ")
                    Spacer()
                    Text(String(totalTanques).toQuilometrosFormat())
                }
                HStack
                {
                    Text("Média custo/km ")
                    Spacer()
                    Text(String(distanciaTotal))
                }
                HStack
                {
                    Text("Média custo litro ")
                    Spacer()
                    Text(String(mediaCustoLitro))
                }
                HStack
                {
                    Text("Custo por dia ")
                    Spacer()
                    Text(String(custoDia).toQuilometrosFormat())
                }
                HStack
                {
                    Text("Quilometros dia ")
                    Spacer()
                    Text(String(distanciaTotal).toQuilometrosFormat())
                }
                HStack
                {
                    Text("Custo por quilometro ")
                    Spacer()
                    Text(String(mediaCustoKM).toCurrencyFormat())
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
            totalTanques = viewModel.getTotalTanques()
            mediaCustoLitro = viewModel.getMediaValorLitro()
            mediaCustoKM = viewModel.getMediaCustoKM()
            custoDia = Double(viewModel.getCustoPorDia())
            print("Dias \(custoDia)")
        }
    }
}
