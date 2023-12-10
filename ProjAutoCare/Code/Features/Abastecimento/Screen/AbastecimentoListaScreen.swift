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
    @State private var adicao = false
    
    var body: some View
    {
        VStack
        {
            List
            {
                ForEach(viewModelAbastecimento.abastecimentosLista) { abastecimento in
                    HStack
                    {
                        AbastecimentoListaDetalheView(abastecimento: abastecimento)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("Exluir", systemImage: "trash", role: .destructive, action: { viewModelAbastecimento.delete(abastecimento: abastecimento)})
                    }
                }
                
                if $viewModelAbastecimento.abastecimentosLista.isEmpty
                {
                    Text("").listRowBackground(Color.clear)
                }
            }
        }.background(Color("backGroundColor"))
        .scrollContentBackground(.hidden)
        .toolbar { ToolbarItem(placement: .navigationBarTrailing)
            { Button {
                viewModel.didTapAdd()
                print("Add")
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

        func didTapCustom() 
        {
           // coordinator?.handle(ShapesAction.customShapes)
        }
    }
}
