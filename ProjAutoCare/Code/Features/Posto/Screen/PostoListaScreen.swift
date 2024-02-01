//
//  PostoListaScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 29/06/23.
//

import SwiftUI
import SwiftUICoordinator

@available(iOS 17.0, *)
struct PostoListaScreen<Coordinator: Routing>: View
{
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewModel = ViewModel<Coordinator>()
    @StateObject var viewModelPosto = PostoViewModel()
    
    var body: some View
    {
        VStack
        {
            List
            {
                ForEach(viewModelPosto.postosLista) { posto in
                    HStack
                    {
                        PostoListaDetalheView<PostoCoordinator>(posto: posto)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("Exluir", role: .destructive, action: { viewModelPosto.delete(posto: posto)})
                    }
                }
                
                if viewModelPosto.postosLista.isEmpty
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

@available(iOS 17.0, *)
extension PostoListaScreen
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
