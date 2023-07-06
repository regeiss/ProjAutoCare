//
//  PostoViewModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 26/06/23.
//

import SwiftUI
import CoreData
import FormValidator

enum PostoFocusable: Hashable
{
    case nome
    case logo
}

class PostoFormInfo: ObservableObject
{
    @Published var manager = FormManager(validationType: .deferred)
    @FormField(validator: NonEmptyValidator(message: "Preencha este campo!"))
    var nome: String = ""
    lazy var nomeVazio = _nome.validation(manager: manager)
    
    @FormField(validator: NonEmptyValidator(message: "Preencha este campo!"))
    var bandeira: String = ""
    lazy var bandeiraVazio = _bandeira.validation(manager: manager)
}

@available(iOS 16.0, *)
struct PostoScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: PostoViewModel
    @ObservedObject var formInfo = PostoFormInfo()
    @FocusState private var postoInFocus: PostoFocusable?
    @State var isSaveDisabled: Bool = true
    
    var posto: Posto
    var isEdit: Bool
    
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
            if isEdit
            {
                formInfo.nome = posto.nome ?? ""
                formInfo.bandeira = posto.bandeira ?? ""
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
                dismiss()
            }
            label: { Text("OK").disabled(isSaveDisabled)}
            }
        }
    }
    
    func save()
    {
        let valid = formInfo.manager.triggerValidation()
        if valid
        {
            if isEdit
            {
                posto.nome = formInfo.nome
                posto.bandeira = formInfo.bandeira
                viewModel.update(posto: posto)
            }
            else
            {
                let postoNovo = PostoDTO(id: UUID(), nome: formInfo.nome, bandeira: formInfo.bandeira, padrao: false)
                viewModel.add(posto: postoNovo)
            }
        }
    }
}
