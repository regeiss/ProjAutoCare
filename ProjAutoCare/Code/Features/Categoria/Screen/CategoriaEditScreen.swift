//
//  CategoriaEditScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 23/07/23.
//

import SwiftUI
import FormValidator

struct CategoriaEditScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: CategoriaViewModel
    @StateObject var formInfo = CategoriaFormInfo()
    @FocusState private var categoriaInFocus: CategoriaFocusable?
    @State var isSaveDisabled: Bool = true
    @State var lista = false
    
    var categoria: Categoria
    
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
            formInfo.nome = categoria.nome ?? ""
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
                lista = true
            }
            label: { Text("OK").disabled(isSaveDisabled)}
            }
        }
        .navigationDestination(isPresented: $lista, destination: {
            CategoriaListaScreen()
        })
    }
    
    func save()
    {
        let valid = formInfo.manager.triggerValidation()
        if valid
        {
            categoria.nome = formInfo.nome
            viewModel.update(categoria: categoria)
        }
    }
}
