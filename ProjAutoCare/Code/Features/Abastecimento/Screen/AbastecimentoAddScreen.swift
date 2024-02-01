//
//  AbastecimentoAddScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 11/08/23.
//

import SwiftUI
import SwiftUICoordinator

struct AbastecimentoAddScreen<Coordinator: Routing>: View
{
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewModel = ViewModel<Coordinator>()
    @EnvironmentObject var errorHandling: ErrorHandling
    
    @StateObject private var viewModelAbastecimento = AbastecimentoViewModel()
    @StateObject private var viewModelPosto = PostoViewModel()
    @StateObject private var viewModelVeiculo = VeiculoViewModel()
    @StateObject private var viewModelRegistro = RegistroViewModel()
    
    @ObservedObject var formInfo = AbastecimentoFormInfo()
    @State var isSaveDisabled: Bool = true
    @FocusState private var abastecimentoInFocus: AbastecimentoFocusable?
    @State var posto: Posto?

    var appState = AppState.shared
    
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
                            Text(posto.nome ?? "").tag(posto as Posto?)
                        }
                    }.pickerStyle(.automatic)
                }
            }.scrollContentBackground(.hidden)
        }
        .onAppear { viewModel.coordinator = coordinator }
        .onReceive(formInfo.manager.$allValid) { isValid in self.isSaveDisabled = !isValid}
        .background(Color("backGroundColor"))
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading)
            { Button("Cancelar") {
                viewModel.popView()
            }}
            ToolbarItem(placement: .navigationBarTrailing)
            { 
                Button("OK") {
                    gravarAbastecimento()
                    viewModel.popView()
                }.disabled(isSaveDisabled)
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
                       media: viewModelAbastecimento.calculaMedia(kmAtual: (Int32(formInfo.quilometragem) ?? 0), litros: (Double(formInfo.litros) ?? 0), appState: appState, primeiraVez: false),
                       noPosto: postoPicker ?? Posto(context: PersistenceController.shared.container.viewContext),
                       doVeiculo: veiculoAtual ?? Veiculo(context: PersistenceController.shared.container.viewContext))
         
        viewModelAbastecimento.add(abastecimento: uab)
        
        let registro = RegistroDTO(id: UUID(), data: Date(), tipo: "AB", idTipo: uab.id)
        viewModelRegistro.add(registro: registro )
    }
    
    func gravarAbastecimento()
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
}

extension AbastecimentoAddScreen
{
    @MainActor class ViewModel<R: Routing>: ObservableObject
    {
        var coordinator: R?
        
        func popView()
        {
            coordinator?.pop(animated: true)
        }
    }
}
