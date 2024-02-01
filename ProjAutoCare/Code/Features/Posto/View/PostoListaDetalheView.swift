//
//  PostoListaDetalheView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 26/06/23.
//

import CoreData
import SwiftUI
import SwiftUICoordinator

@available(iOS 17.0, *)
struct PostoListaDetalheView<Coordinator: Routing>: View
{
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewModel = ViewModel<Coordinator>()

    var posto: Posto
    
    var body: some View
    {
        HStack
        {
            Text(posto.nome ?? "")
            Text(posto.bandeira ?? "")
        }
        .onTapGesture
        {
            // appState.abastecimentoSelecionado = abastecimento
            viewModel.didTapList()
        }
        .onAppear {
            viewModel.coordinator = coordinator
        }
    }
}

@available(iOS 17.0, *)
extension PostoListaDetalheView
{
    @MainActor
    class ViewModel<R: Routing>: ObservableObject
    {
        var coordinator: R?
        
        func didTapList()
        {
            coordinator?.handle(PostoAction.leitura)
        }
    }
}
