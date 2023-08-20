//
//  AbastecimentoAddScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 11/08/23.
//

import SwiftUI

struct AbastecimentoAddScreen: View 
{
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var errorHandling: ErrorHandling
    
    @StateObject private var viewModel = AbastecimentoViewModel()
    @StateObject private var viewModelPosto = PostoViewModel()
    @StateObject private var viewModelVeiculo = VeiculoViewModel()
    @StateObject private var viewModelRegistro = RegistroViewModel()
    
    @ObservedObject var formInfo = AbastecimentoFormInfo()
    @State var isSaveDisabled: Bool = true
    @FocusState private var abastecimentoInFocus: AbastecimentoFocusable?
    @State var posto: Posto?

    var appState = AppState.shared
    var isEdit: Bool
    
    let loc = Locale(identifier: "pt_BR")
    
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
        }.onReceive(formInfo.manager.$allValid) { isValid in self.isSaveDisabled = !isValid}
        .background(Color("backGroundColor"))
        .navigationTitle("Abastecimento")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading)
            { Button("Cancelar") {
                dismiss()}
                }
            ToolbarItem(placement: .navigationBarTrailing)
            { 
                Button("OK") {
                    gravarAbastecimento()
                    dismiss()}.disabled(isSaveDisabled)
            }
        }
    }
    
    private func saveAbastecimento() throws
    {
        var postoPicker: Posto?
        var veiculoAtual: Veiculo?
        
        if posto == nil
        {
            postoPicker = appState.postoPadrao
            
        }
        else
        {
            postoPicker = posto
        }
        
                if appState.veiculoAtivo == nil
                {
                    veiculoAtual = viewModelVeiculo.veiculosLista.first
                }
                else
                {
                    veiculoAtual = appState.veiculoAtivo
                }
        
        let uab = AbastecimentoDTO(id: UUID(),
                       quilometragem: (Int32(formInfo.quilometragem) ?? 0),
                       data: formInfo.data,
                       litros: (Double(formInfo.litros) ?? 0),
                       valorLitro: (Double(formInfo.valorLitro) ?? 0),
                       valorTotal: ((Double(formInfo.litros) ?? 0) * (Double(formInfo.valorLitro) ?? 0)),
                       completo: Bool(formInfo.completo),
                       media: calculaMedia(kmAtual: Int32(formInfo.quilometragem) ?? 0,
                       litros: Double(formInfo.litros) ?? 0),
                       noPosto: postoPicker!,
                       doVeiculo: veiculoAtual!)
         
        viewModel.add(abastecimento: uab)
        
        let registro = RegistroDTO(id: UUID(), data: Date(), tipo: "AB", idTipo: uab.id)
        viewModelRegistro.add(registro: registro )
    }
    
    private func gravarAbastecimento()
    {
        let valid = formInfo.manager.triggerValidation()
        if valid
        {
            do
            {
                try saveAbastecimento()
            }
            
            catch
            {
                self.errorHandling.handle(error: error)
            }
        }
    }
    
    private func calculaMedia(kmAtual: Int32, litros: Double) -> Double
    {
        var media: Double
        var kmPercorrida: Int32
        
        if viewModel.abastecimentosLista.count == 0
        {
            return 0
        }
        else
        {
            kmPercorrida = kmAtual - appState.ultimaKM
            media = Double(kmPercorrida) / (Double(formInfo.litros) ?? 0)
            return media
        }
    }
}
