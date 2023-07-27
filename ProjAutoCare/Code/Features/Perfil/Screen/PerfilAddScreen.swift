//
//  PerfilAddScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 24/07/23.
//

import SwiftUI
import FormValidator

struct PerfilAddScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: PerfilViewModel
    @StateObject var formInfo = PerfilFormInfo()
    @FocusState private var perfilInFocus: PerfilFocusable?
    @State var isSaveDisabled = true
    @State var lista = false
    
    var body: some View
    {
        VStack(alignment: .leading)
        {
            Form
            {
                Section
                {
                    TextField("nome", text: $formInfo.nome)
                        .autocorrectionDisabled(true)
                        .validation(formInfo.nomeVazio)
                        .focused($perfilInFocus, equals: .nome)
                        .onAppear{ DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {self.perfilInFocus = .nome}}
                    
                    TextField("email", text: $formInfo.email)
                        .autocorrectionDisabled(true)
                        .validation(formInfo.emailInvalido)
                        .keyboardType(.emailAddress)
                }
            }
            .scrollContentBackground(.hidden)
            .onReceive(formInfo.manager.$allValid) { isValid in
                self.isSaveDisabled = !isValid}
        }
        .background(Color("backGroundColor"))
        .navigationTitle("Perfis")
        .navigationBarTitleDisplayMode(.automatic)
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
            PerfilListaScreen()
        })
    }
    
    func save()
    {
        let valid = formInfo.manager.triggerValidation()
        if valid
        {
            let perfilNovo = PerfilDTO(id: UUID(), nome: formInfo.nome, email: formInfo.email, ativo: false, padrao: false)
            viewModel.add(perfil: perfilNovo)
        }
    }
}
