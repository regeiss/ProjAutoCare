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
                    Text(String(abastecimento?.quilometragem ?? 0))
                    // Text(String(abastecimento.data))
                    Text(String(abastecimento?.litros ?? 0))
                    Text(String(abastecimento?.valorLitro ?? 0))
                    Text("Valor total \(valorTotal)")
//                    Toggle(isOn: $abastecimento?.completo ?? false)
//                    {
//                        Text("completo")
//                    }
                    
                    Text(abastecimento?.self.nomePosto ?? "")
                }
            }
            .disabled(true)
            .scrollContentBackground(.hidden)
        }
        .onAppear
        {
            print("onAppear")
            abastecimento = appState.abastecimentoSelecionado!
            viewModel.coordinator = coordinator
        }
        .onDisappear{
            print("onDisapear")
        }
        
        .background(Color("backGroundColor"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing)
            { Button {
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
