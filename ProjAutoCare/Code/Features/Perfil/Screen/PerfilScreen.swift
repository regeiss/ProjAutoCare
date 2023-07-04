//
//  PerfilScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 16/06/23.
//

import SwiftUI
import CoreData
import FormValidator

enum PerfilFocusable: Hashable
{
    case nome
    case email
    case ativo
}

class PerfilFormInfo: ObservableObject
{
    @Published var manager = FormManager(validationType: .deferred)
    @FormField(validator: NonEmptyValidator(message: "Preencha este campo!"))
    var nome: String = ""
    lazy var nomeVazio = _nome.validation(manager: manager)
    var email: String = ""
}

@available(iOS 16.0, *)
struct PerfilScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = PerfilViewModel()
    @ObservedObject var formInfo = PerfilFormInfo()
    @FocusState private var perfilInFocus: PostoFocusable?
    @State var isSaveDisabled = true
    
    var perfil: Perfil
    var isEdit: Bool
    
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
                }
            }
            .scrollContentBackground(.hidden)
//            .onReceive(formInfo.manager.$allValid) { isValid in
//                self.isSaveDisabled = !isValid}
        }.onAppear
        {
            if isEdit
            {
                formInfo.nome = perfil.nome ?? ""
                formInfo.email = perfil.email ?? ""
            }
        }
        .background(Color("backGroundColor"))
        .navigationTitle("Postos")
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
                // dismiss()
            }
            label: { Text("OK")}
            }
        }
    }
    
    func save()
    {
        let valid = true // formInfo.manager.triggerValidation()
        if valid
        {
            if isEdit
            {
                perfil.nome = formInfo.nome
                viewModel.update(perfil: perfil)
            }
            else
            {
                let perfilNovo = PerfilDTO(id: UUID(), nome: formInfo.nome, email: formInfo.email, ativo: false, padrao: false)
                viewModel.add(perfil: perfilNovo)
            }
        }
    }
}
