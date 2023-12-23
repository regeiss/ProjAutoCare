//
//  AbastecimentoEditScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/08/23.
//

import SwiftUI
import SwiftUICoordinator

struct AbastecimentoEditScreen<Coordinator: Routing>: View
{
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewModel = ViewModel<Coordinator>()
    
    @EnvironmentObject var errorHandling: ErrorHandling
    
    @StateObject var viewModelPosto = PostoViewModel()
    @StateObject var viewModelVeiculo = VeiculoViewModel()
    @StateObject var viewModelRegistro = RegistroViewModel()
    @StateObject var viewModelAbastecimento = AbastecimentoViewModel()
    
    @ObservedObject var formInfo = AbastecimentoFormInfo()
    @State var isSaveDisabled: Bool = true
    @FocusState private var abastecimentoInFocus: AbastecimentoFocusable?
    @State var posto: Posto?
    
    @State var abastecimento: Abastecimento = Abastecimento(context: PersistenceController.shared.container.viewContext)
    @State var appState = AppState.shared
    
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
                    }
                    .pickerStyle(.automatic)
                    .onAppear {
                        posto = abastecimento.noPosto
                    }
                }.onAppear
                {
                    abastecimento = appState.abastecimentoItemLista ?? Abastecimento()
                    formInfo.quilometragem = String(abastecimento.quilometragem)
                    formInfo.data = abastecimento.data ?? Date()
                    formInfo.litros = String(abastecimento.litros)
                    formInfo.valorLitro = String(abastecimento.valorLitro)
                    formInfo.completo = abastecimento.completo
                }
            }.scrollContentBackground(.hidden)
        }
        .onAppear { viewModel.coordinator = coordinator }
        .onReceive(formInfo.manager.$allValid) { isValid in self.isSaveDisabled = !isValid}
        .background(Color("backGroundColor"))
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading)
            { Button {
                viewModel.popView()
            }
                label: { Text("Cancelar")}}
            ToolbarItem(placement: .navigationBarTrailing)
            { Button {
                save()
                appState.abastecimentoItemLista = abastecimento
                viewModel.popView()
            }
            label: { Text("OK").disabled(isSaveDisabled)}
            }
        }
    }
    
    func save()
    {
        var veiculoAtual: Veiculo?
        let valid = formInfo.manager.triggerValidation()
        if valid
        {
            if appState.veiculoAtivo == nil
            {
                veiculoAtual = viewModelVeiculo.veiculosLista.first
            }
            else
            {
                veiculoAtual = appState.veiculoAtivo
            }
            
            abastecimento.quilometragem = Int32(formInfo.quilometragem) ?? 0
        
            abastecimento.data = formInfo.data
            abastecimento.litros = (Double(formInfo.litros) ?? 0)
            abastecimento.valorLitro = (Double(formInfo.valorLitro) ?? 0)
            abastecimento.valorTotal = ((Double(formInfo.litros) ?? 0) * (Double(formInfo.valorLitro) ?? 0))
            abastecimento.completo = Bool(formInfo.completo)
            abastecimento.media = viewModelAbastecimento.calculaMedia(kmAtual: (Int32(formInfo.quilometragem) ?? 0), litros: (Double(formInfo.litros) ?? 0), appState: appState, primeiraVez: false)
            abastecimento.noPosto = posto
            abastecimento.doVeiculo = veiculoAtual!
            viewModelAbastecimento.update(abastecimento: abastecimento)
        }
    }
}

extension AbastecimentoEditScreen
{
    @MainActor class ViewModel<R: Routing>: ObservableObject
    {
        var coordinator: R?
        
        func popView()
        {
            coordinator?.pop(animated: true)
        }
        
        func returnToList()
        {
            coordinator?.handle(AbastecimentoAction.lista)
        }
    }
}
