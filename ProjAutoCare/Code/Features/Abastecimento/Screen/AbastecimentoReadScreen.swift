//
//  AbastecimentoReadScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/08/23.
//

import SwiftUI

struct AbastecimentoReadScreen: View 
{
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var errorHandling: ErrorHandling
    
    @ObservedObject var viewModel = AbastecimentoViewModel()
    @StateObject var viewModelPosto = PostoViewModel()
    
    @StateObject var formInfo = AbastecimentoFormInfo()
    @State var edicao = false
    
    var abastecimento: Abastecimento
    var appState = AppState.shared
    var valorTotal: String
    {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let total = (Double(formInfo.litros) ?? 0) * (Double(formInfo.valorLitro) ?? 0)
        
        return formatter.string(from: NSNumber(value: total)) ?? "$0"
    }
    
    var body: some View
    {
        VStack
        {
            Form
            {
                Section
                {
                    TextField("km", text: $formInfo.quilometragem)
                    DatePicker("data", selection: $formInfo.data)
                        .frame(maxHeight: 400)
                        .environment(\.locale, Locale.init(identifier: "pt-BR"))
                    TextField("litros", text: $formInfo.litros)
                    TextField("valorLitro", text: $formInfo.valorLitro)
                    Text("Valor total \(valorTotal)")
                    Toggle(isOn: $formInfo.completo)
                    {
                        Text("completo")
                    }

                    Text(abastecimento.nomePosto)
                }
            }.disabled(true)
            .scrollContentBackground(.hidden)
            .onAppear
            {
                formInfo.quilometragem = String(abastecimento.quilometragem)
                formInfo.data = abastecimento.data ?? Date()
                formInfo.litros = String(abastecimento.litros)
                formInfo.valorLitro = String(abastecimento.valorLitro)
                formInfo.completo = abastecimento.completo
            }
        }
        .background(Color("backGroundColor"))
        .navigationTitle("Abastecimento")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing)
            { Button {
                edicao = true
            }
            label: { Text("Editar")}
            }
        }
        .navigationDestination(isPresented: $edicao, destination: {
            AbastecimentoEditScreen(abastecimento: abastecimento)
        })
    }
}
