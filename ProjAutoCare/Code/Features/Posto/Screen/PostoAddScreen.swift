//
//  PostoAddScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 24/07/23.
//

import SwiftUI
import SwiftUICoordinator

struct PostoAddScreen<Coordinator: Routing>: View
{
    @EnvironmentObject var coordinator: Coordinator
    @ObservedObject var viewModelPosto = PostoViewModel()
    @ObservedObject var formInfo = PostoFormInfo()
    @FocusState private var postoInFocus: PostoFocusable?
    @StateObject var viewModel = ViewModel<Coordinator>()
    @State var isSaveDisabled: Bool = true
    
    var body: some View
    {
        VStack
        {
            Form
            {
                Section
                {
                    TextField("nome", text: $formInfo.nome)
                        .autocorrectionDisabled(true)
                        .validation(formInfo.nomeVazio)
                        .focused($postoInFocus, equals: .nome)
                        .onAppear{ DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) { self.postoInFocus = .nome}}
                    
                    TextField("bandeira", text: $formInfo.bandeira)
                        .validation(formInfo.bandeiraVazio)
                }
            }
            .scrollContentBackground(.hidden)
            .onReceive(formInfo.manager.$allValid) { isValid in
                self.isSaveDisabled = !isValid}
        }
        .onAppear { viewModel.coordinator = coordinator }
        .background(Color("backGroundColor"))
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading)
            { Button("Cancelar") {
                viewModel.popView()
            }}
            ToolbarItem(placement: .navigationBarTrailing)
            {
                Button("OK") {
                    //gravarAbastecimento()
                    viewModel.popView()
                }.disabled(isSaveDisabled)
            }
        }
    }
    
    func savePosto()
    {
        let valid = formInfo.manager.triggerValidation()
        if valid
        {
            let postoNovo = PostoDTO(id: UUID(), nome: formInfo.nome, bandeira: formInfo.bandeira, padrao: false)
            viewModelPosto.add(posto: postoNovo)
        }
    }
}

extension PostoAddScreen
{
    @MainActor class ViewModel<R: Routing>: ObservableObject
    {
        var coordinator: R?
        
        func popView()
        {
            coordinator?.pop(animated: true)
        }
        
    }
}
