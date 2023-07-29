//
//  PostoEditScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 24/07/23.
//

import SwiftUI

struct PostoEditScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: PostoViewModel
    @StateObject var formInfo = PostoFormInfo()
    @FocusState private var postoInFocus: PostoFocusable?
    @State var isSaveDisabled: Bool = true
    @State var lista = false
    
    var posto: Posto
    
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
                        .onAppear{ DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {self.postoInFocus = .nome}}
                    
                    TextField("bandeira", text: $formInfo.bandeira)
                        .validation(formInfo.bandeiraVazio)
                }
            }
            .scrollContentBackground(.hidden)
            .onReceive(formInfo.manager.$allValid) { isValid in
                self.isSaveDisabled = !isValid}
        }.onAppear
        {
            formInfo.nome = posto.nome ?? ""
            formInfo.bandeira = posto.bandeira ?? ""
        }
        .background(Color("backGroundColor"))
        .navigationTitle("Postos")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading)
            { Button {
                dismiss()
            }
                label: { Text("Cancelar")}}
            ToolbarItem(placement: .navigationBarTrailing)
            { Button {
                save()
                lista = true
            }
            label: { Text("OK").disabled(isSaveDisabled)}
            }
        }
        .navigationDestination(isPresented: $lista, destination: {
            PostoListaScreen()})
    }
    
    func save()
    {
        let valid = formInfo.manager.triggerValidation()
        if valid
        {
            posto.nome = formInfo.nome
            posto.bandeira = formInfo.bandeira
            viewModel.update(posto: posto)
        }
    }
}
