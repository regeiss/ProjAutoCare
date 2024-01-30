//
//  AbastecimentoListaDetalheView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/06/23.
//
import CoreData
import SwiftUI
import SwiftUICoordinator

struct AbastecimentoListaDetalheView<Coordinator: Routing>: View
{
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewModel = ViewModel<Coordinator>()
    @StateObject var viewModelAbastecimento = AbastecimentoViewModel()
    
    var abastecimento: Abastecimento
    var appState = AppState.shared
    
    var body: some View
    {
        HStack
        {
            Label("gas", systemImage: "fuelpump.circle")
                .labelStyle(.iconOnly)
                .imageScale(.large)
            
            VStack
            {
                HStack
                {
                    Text("Data: ")
                    Text(abastecimento.data ?? Date(), format: Date.FormatStyle().year().month().day())
                    Spacer()
                }
                
                HStack
                {
                    Text("Total: "); Text(String(format: "%.2f", abastecimento.valorTotal).toCurrencyFormat())
                    Spacer()
                    if abastecimento.media > 0 {
                        Text(String(format: "%.2f", abastecimento.media)); Text(" km/l")}
                }
                HStack
                {
                    Text("Odômetro: ")
                    Text(String(abastecimento.quilometragem).toQuilometrosFormat())
                    Spacer(); Text("Litros: "); Text(String(format: "%.2f", abastecimento.litros))
                }
                HStack
                {
                    Text("Posto: ")
                    Text(abastecimento.nomePosto)
                    Spacer()
                }
            }
            .padding(.all, 2)
        }
        .onAppear
        {
            viewModel.coordinator = coordinator
        }
        .onTapGesture
        {
            appState.abastecimentoSelecionado = abastecimento
            viewModel.didTapList()
        }
    }
}

extension AbastecimentoListaDetalheView
{
    @MainActor
    class ViewModel<R: Routing>: ObservableObject
    {
        var coordinator: R?
        
        func didTapList()
        {
            coordinator?.handle(AbastecimentoAction.leitura)
        }
    }
}

extension Abastecimento
{
    @objc
    var nomePosto: String
    {
        self.noPosto?.nome ?? "não informado"
    }
    
    @objc
    var nomeCarro: String
    {
        self.doVeiculo?.nome ?? "não informado"
    }
}
