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
    
    @ObservedObject var viewModel: AbastecimentoViewModel
    @StateObject private var viewModelPosto = PostoViewModel()
    @StateObject private var viewModelVeiculo = VeiculoViewModel()
    
    @StateObject var formInfo = AbastecimentoFormInfo()
    @State var isSaveDisabled: Bool = true
    @State var posto: Posto?
    @State private var edicao = false
    
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
                    
                    Picker("Posto:", selection: $posto)
                    {
                        Text("Nenhum").tag(Posto?.none)
                        ForEach(viewModelPosto.postosLista) { (posto: Posto) in
                            Text(posto.nome!).tag(posto as Posto?)
                        }
                    }.pickerStyle(.automatic)
                }.disabled(true)
            }
            .scrollContentBackground(.hidden)
            .onAppear
            {
                formInfo.quilometragem = String(abastecimento.quilometragem)
                formInfo.data = abastecimento.data ?? Date()
                formInfo.litros = String(abastecimento.litros)
                formInfo.valorLitro = String(abastecimento.valorLitro)
            }
        }
        .background(Color("backGroundColor"))
        .navigationTitle("Abastecimento")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading)
            { Button {
                dismiss()
            }
                label: { Text("Cancelar")}}
            ToolbarItem(placement: .navigationBarTrailing)
            { Button {
                edicao = true
            }
            label: { Text("Editar")}
            }
        }
        .navigationDestination(isPresented: $edicao, destination: {
            AbastecimentoEditScreen(abastecimento: abastecimento, viewModel: viewModel)
        })
    }
}
