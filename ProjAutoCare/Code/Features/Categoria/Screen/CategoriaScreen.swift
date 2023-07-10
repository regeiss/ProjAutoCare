//
//  CategoriaScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 09/07/23.
//

import SwiftUI
import CoreData
import FormValidator

enum CategoriaFocusable: Hashable
{
    case nome
}

class CategoriaFormInfo: ObservableObject
{
    @Published var manager = FormManager(validationType: .deferred)
    @FormField(validator: NonEmptyValidator(message: "Preencha este campo!"))
    var nome: String = ""
    lazy var nomeVazio = _nome.validation(manager: manager)
}

@available(iOS 16.0, *)
struct CategoriaScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: CategoriaViewModel
    @ObservedObject var formInfo = CategoriaFormInfo()
    @FocusState private var categoriaInFocus: CategoriaFocusable?
    @State var isSaveDisabled: Bool = true
    
    var categoria: Categoria
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
                        .focused($categoriaInFocus, equals: .nome)
                        .onAppear{ DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {self.categoriaInFocus = .nome}}
                }
            }
            .scrollContentBackground(.hidden)
            .onReceive(formInfo.manager.$allValid) { isValid in
                self.isSaveDisabled = !isValid}
        }.onAppear
        {
            if isEdit
            {
                formInfo.nome = categoria.nome ?? ""
            }
        }
        .background(Color("backGroundColor"))
        .navigationTitle("Posto")
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
                categoria.nome = formInfo.nome
                // servico.bandeira = formInfo.bandeira
                viewModel.update(categoria: categoria)
            }
            else
            {
                let categoriaNovo = CategoriaDTO(id: UUID(), nome: formInfo.nome)
                viewModel.add(categoria: categoriaNovo)
            }
        }
    }
}
