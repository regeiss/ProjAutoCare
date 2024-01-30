//
//  AbastecimentoReadScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/08/23.
//

import CoreData
import SwiftUI
import SwiftUICoordinator

struct AbastecimentoReadScreen<Coordinator: Routing>: View
{
    @EnvironmentObject var errorHandling: ErrorHandling
    @EnvironmentObject var coordinator: Coordinator
    
    @StateObject var viewModel = ViewModel<Coordinator>()
    @StateObject var viewModelPosto = PostoViewModel()
    @StateObject var appState = AppState.shared
    
    @State var abastecimento: Abastecimento?
    @State var quilometragem: Int32 = 0
    @State var litros: Double = 0
    @State var valorLitro: Double = 0
    @State var completo: Bool = false
    @State var dataAbastecimento: Date = Date()
    
    var valorTotal: String
    {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let total = (Double(abastecimento?.litros ?? 0) * Double(abastecimento?.valorLitro ?? 0))
        
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
                    Text(String(quilometragem).toQuilometrosFormat())
                    DatePicker("data", selection: $dataAbastecimento)
                        .environment(\.locale, Locale.init(identifier: "pt-BR"))
                    Text(String(litros).toMediaConsumoFormat())
                    Text(String(valorLitro).toCurrencyFormat())
                    Text("Valor total \(valorTotal)")
                    Toggle(isOn: $completo)
                    {
                        Text("completo")
                    }
                    
                    Text(abastecimento?.self.nomePosto ?? "")
                }
            }
            .disabled(true)
            .scrollContentBackground(.hidden)
        }
        .onAppear
        {
            abastecimento = appState.abastecimentoSelecionado!
            quilometragem = abastecimento?.quilometragem ?? 0
            litros = abastecimento?.litros ?? 0
            valorLitro = abastecimento?.valorLitro ?? 0
            dataAbastecimento = abastecimento?.data ?? Date()
            completo = abastecimento?.completo ?? false
            viewModel.coordinator = coordinator
        }
        .onDisappear{
            print("onDisapear")
        }
        .background(Color("backGroundColor"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing)
            { Button {
                appState.abastecimentoSelecionado = abastecimento
                viewModel.didTapEdit()
            }
            label: { Text("Editar")}
            }
        }
    }
}

extension AbastecimentoReadScreen
{
    @MainActor class ViewModel<R: Routing>: ObservableObject
    {
        var coordinator: R?
        
        func didTapEdit()
        {
            coordinator?.handle(AbastecimentoAction.edicao)
        }
        
        func returnToList()
        {
            coordinator?.handle(AbastecimentoAction.lista)
        }
    }
}
