//
//  PostoAddScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 24/07/23.
//

import SwiftUI
import FormValidator

struct PostoAddScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: PostoViewModel
    @ObservedObject var formInfo = PostoFormInfo()
    @FocusState private var postoInFocus: PostoFocusable?
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
            let postoNovo = PostoDTO(id: UUID(), nome: formInfo.nome, bandeira: formInfo.bandeira, padrao: false)
            viewModel.add(posto: postoNovo)
        }
    }
}
