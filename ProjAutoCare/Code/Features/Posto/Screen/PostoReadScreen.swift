//
//  PostoReadScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 24/07/23.
//

import SwiftUI
import SwiftUICoordinator

struct PostoReadScreen<Coordinator: Routing>: View
{
    @EnvironmentObject var errorHandling: ErrorHandling
    @EnvironmentObject var coordinator: Coordinator
    @ObservedObject var formInfo = PostoFormInfo()
    @StateObject var viewModel = ViewModel<Coordinator>()

    @State var posto: Posto?
    
    var body: some View
    {
        VStack
        {
            Form
            {
                Section
                {
                    TextField("nome", text: $formInfo.nome).disabled(true)
                    TextField("bandeira", text: $formInfo.bandeira).disabled(true)
                }
            }
            .scrollContentBackground(.hidden)
        }.onAppear
        {
            formInfo.nome = posto?.nome ?? ""
            formInfo.bandeira = posto?.bandeira ?? ""
            viewModel.coordinator = coordinator
        }
        .background(Color("backGroundColor"))
        .navigationTitle("Postos")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing)
            { Button {
                // appState.abastecimentoSelecionado = abastecimento
                viewModel.didTapEdit()
            }
            label: { Text("Editar")}
            }
        }
    }
}

extension PostoReadScreen
{
    @MainActor class ViewModel<R: Routing>: ObservableObject
    {
        var coordinator: R?
        
        func didTapEdit()
        {
            coordinator?.handle(PostoAction.edicao)
        }
    }
}
