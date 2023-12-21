//
//  AbastecimentoReadScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/08/23.
//

import SwiftUI
import SwiftUICoordinator
import CoreData

struct AbastecimentoReadScreen<Coordinator: Routing>: View
{
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var errorHandling: ErrorHandling
    @StateObject var viewModel = ViewModel<Coordinator>()
    @StateObject var viewModelPosto = PostoViewModel()
    @StateObject var formInfo = AbastecimentoFormInfo()
    @State var edicao = false
    @State var abastecimento: Abastecimento = Abastecimento(context: PersistenceController.shared.container.viewContext)
    
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
            }
            .disabled(true)
            .scrollContentBackground(.hidden)
            .onAppear
            {
                abastecimento = appState.abastecimentoItemLista ?? Abastecimento()
                formInfo.quilometragem = String(abastecimento.quilometragem)
                formInfo.data = abastecimento.data ?? Date()
                formInfo.litros = String(abastecimento.litros)
                formInfo.valorLitro = String(abastecimento.valorLitro)
                formInfo.completo = abastecimento.completo
            }
        }
        .onAppear {
            viewModel.coordinator = coordinator
            
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
    }
}
