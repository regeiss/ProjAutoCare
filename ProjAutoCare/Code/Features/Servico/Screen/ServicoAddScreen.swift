//
//  ServicoAddScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 24/07/23.
//

import SwiftUI

struct ServicoAddScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ServicoViewModel
    @ObservedObject var formInfo = ServicoFormInfo()
    @FocusState private var servicoInFocus: ServicoFocusable?
    @StateObject private var viewModelCategoria = CategoriaViewModel()
    @State var isSaveDisabled: Bool = true
    @State var categoria: Categoria?
    
    var body: some View
    {
        VStack
        {
            Form
            {
                Section
                {
                    Picker("Categoria:", selection: $categoria)
                    {
                        Text("Nenhum").tag(Posto?.none)
                        ForEach(viewModelCategoria.categoriaLista) { (categoria: Categoria) in
                            Text(categoria.nome!).tag(categoria as Categoria?)
                        }
                    }
                    .pickerStyle(.automatic)
                    .onAppear {
                            categoria = viewModelCategoria.categoriaLista.first}
                    TextField("nome", text: $formInfo.nome)
                        .autocorrectionDisabled(true)
                        .validation(formInfo.nomeVazio)
                        .focused($servicoInFocus, equals: .nome)
                        .onAppear{ DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {self.servicoInFocus = .nome}}
                }
            }
            .scrollContentBackground(.hidden)
            .onReceive(formInfo.manager.$allValid) { isValid in
                self.isSaveDisabled = !isValid}
        }
        .background(Color("backGroundColor"))
        .navigationTitle("Serviço")
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
            let servicoNovo = ServicoDTO(id: UUID(), nome: formInfo.nome, daCategoria: categoria!)
            viewModel.add(servico: servicoNovo)
        }
    }
}
