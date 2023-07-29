//
//  CategoriaAddScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 23/07/23.
//

import SwiftUI
import FormValidator

struct CategoriaAddScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: CategoriaViewModel
    @ObservedObject var formInfo = CategoriaFormInfo()
    @FocusState private var categoriaInFocus: CategoriaFocusable?
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
                        .focused($categoriaInFocus, equals: .nome)
                        .onAppear{ DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {self.categoriaInFocus = .nome}}
                }
            }
            .scrollContentBackground(.hidden)
            .onReceive(formInfo.manager.$allValid) { isValid in
                self.isSaveDisabled = !isValid}
        }
        .background(Color("backGroundColor"))
        .navigationTitle("Categoria")
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
            let categoriaNovo = CategoriaDTO(id: UUID(), nome: formInfo.nome)
            viewModel.add(categoria: categoriaNovo)
        }
    }
}
