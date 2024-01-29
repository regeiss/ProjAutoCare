//
//  AbastecimentoListaScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/06/23.
//

import SwiftUI
import SwiftUICoordinator

struct AbastecimentoListaScreen<Coordinator: Routing>: View
{
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewModel = ViewModel<Coordinator>()
    @StateObject var viewModelAbastecimento = AbastecimentoViewModel()
    
    var body: some View
    {
        VStack
        {
            List
            {
                ForEach(viewModelAbastecimento.abastecimentosLista) { abastecimento in
                    HStack
                    {
                        AbastecimentoListaDetalheView<AbastecimentoCoordinator>(abastecimento: abastecimento)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("Exluir", role: .destructive, action: { viewModelAbastecimento.delete(abastecimento: abastecimento)})
                    }
                }
                
                if $viewModelAbastecimento.abastecimentosLista.isEmpty
                {
                    Text("").listRowBackground(Color.clear)
                }
            }
        }
        .onAppear { viewModel.coordinator = coordinator }
        .background(Color("backGroundColor"))
        .scrollContentBackground(.hidden)
        .toolbar { ToolbarItem(placement: .navigationBarTrailing)
            { Button {
                viewModel.didTapAdd()
            }
                label: { Image(systemName: "plus")}}
        }
    }
}

extension AbastecimentoListaScreen
{
    @MainActor class ViewModel<R: Routing>: ObservableObject 
    {
        var coordinator: R?

        func didTapAdd() 
        {
            coordinator?.handle(AbastecimentoAction.inclusao)
        }
    }
}
