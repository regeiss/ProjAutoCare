//
//  AbastecimentoEditScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/08/23.
//

import SwiftUI

struct AbastecimentoEditScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var errorHandling: ErrorHandling
    
    @StateObject private var viewModelPosto = PostoViewModel()
    @StateObject private var viewModelVeiculo = VeiculoViewModel()
    @StateObject private var viewModelRegistro = RegistroViewModel()
    
    @ObservedObject var formInfo = AbastecimentoFormInfo()
    @State var isSaveDisabled: Bool = true
    @FocusState private var abastecimentoInFocus: AbastecimentoFocusable?
    @State var posto: Posto?
    @State var lista = false
    
    var abastecimento: Abastecimento
    var viewModel: AbastecimentoViewModel
    
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
                        .focused($abastecimentoInFocus, equals: .quilometragem)
                        .keyboardType(.numbersAndPunctuation)
                        .onAppear{ DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {self.abastecimentoInFocus = .quilometragem}}
                        .validation(formInfo.kmNaoInformado)
                    
                    DatePicker("data", selection: $formInfo.data)
                        .frame(maxHeight: 400)
                        .focused($abastecimentoInFocus, equals: .data)
                        .environment(\.locale, Locale.init(identifier: "pt-BR"))
                        .validation(formInfo.validacaoData)
                    
                    TextField("litros", text: $formInfo.litros)
                        .focused($abastecimentoInFocus, equals: .litros)
                        .keyboardType(.numbersAndPunctuation)
                        .validation(formInfo.litrosNaoInformado)
                    
                    TextField("valorLitro", text: $formInfo.valorLitro)
                        .focused($abastecimentoInFocus, equals: .litros)
                        .keyboardType(.numbersAndPunctuation)
                        .validation(formInfo.valorNaoInformado)
                    
                    Text("Valor total \(valorTotal)")
                    Toggle(isOn: $formInfo.completo)
                    {
                        Text("completo")
                    }.focused($abastecimentoInFocus, equals: .completo)
                    
                    
                    Picker("Posto:", selection: $posto)
                    {
                        Text("Nenhum").tag(Posto?.none)
                        ForEach(viewModelPosto.postosLista) { (posto: Posto) in
                            Text(posto.nome!).tag(posto as Posto?)
                        }
                    }.pickerStyle(.automatic)
                }
            }.scrollContentBackground(.hidden)
        }
        .onReceive(formInfo.manager.$allValid) { isValid in self.isSaveDisabled = !isValid}
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
                save()
                lista = true
            }
            label: { Text("OK").disabled(isSaveDisabled)}
            }
        }
    }
    
    func save()
    {
        let valid = formInfo.manager.triggerValidation()
        if valid
        {
            abastecimento.quilometragem = Int32(formInfo.quilometragem) ?? 0
            
            viewModel.update(abastecimento: abastecimento)
        }
    }
}
