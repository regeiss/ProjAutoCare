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
    @StateObject var viewModelAbastecimento = AbastecimentoViewModel()
    @StateObject var viewModelPosto = PostoViewModel()
    @StateObject var appState = AppState.shared
    @State var abastecimento = Abastecimento(context: PersistenceController.shared.container.viewContext)
    @State var abastecimentoID: UUID?
    
    var valorTotal: String
    {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let total = (Double(abastecimento.litros) * Double(abastecimento.valorLitro))
        
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
                    Text(String(abastecimento.quilometragem))
                    // Text(String(abastecimento.data))
                    Text(String(abastecimento.litros))
                    Text(String(abastecimento.valorLitro))
                    Text("Valor total \(valorTotal)")
                    Toggle(isOn: $abastecimento.completo)
                    {
                        Text("completo")
                    }
                    
                    Text(abastecimento.self.nomePosto)
                }
            }
            .disabled(true)
            .scrollContentBackground(.hidden)
        }
        .onAppear
        {
            print("onAppear")
            abastecimentoID = appState.abastecimentoSelecionadoID
            viewModelAbastecimento.fetchByID(abastecimentoID: abastecimentoID!)
            abastecimento = viewModelAbastecimento.abastecimentosLista.first ?? Abastecimento()
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
