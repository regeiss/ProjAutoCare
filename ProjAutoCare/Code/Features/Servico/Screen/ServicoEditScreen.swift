//
//  ServicoEditScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 24/07/23.
//

import SwiftUI

struct ServicoEditScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ServicoViewModel
    @ObservedObject var viewModelCategoria = CategoriaViewModel()
    @ObservedObject var formInfo = ServicoFormInfo()
    @FocusState private var servicoInFocus: ServicoFocusable?
    @State var isSaveDisabled: Bool = true
    @State var lista = false
    @State var categoria: Categoria?
    
    var servico: Servico
    
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
                        ForEach(viewModelCategoria.categoriaLista) { (categoria: Categoria) in
                            Text(categoria.nome!).tag(categoria as Categoria?)
                        }
                    }.pickerStyle(.automatic)
                        .onAppear { categoria = servico.daCategoria}
                    TextField("nome", text: $formInfo.nome)
                        .autocorrectionDisabled(true)
                        .validation(formInfo.nomeVazio)
                        .focused($servicoInFocus, equals: .nome)
                        .onAppear{ DispatchQueue.main.asyncAfter(deadline: .now() + 0.50)
                            {self.servicoInFocus = .nome
                                formInfo.nome = servico.nome ?? ""}}
                }
            }
            .scrollContentBackground(.hidden)
            .onReceive(formInfo.manager.$allValid) { isValid in
                self.isSaveDisabled = !isValid}
        }.onAppear
        {
            formInfo.nome = servico.nome ?? ""
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
                lista = true
                }
                label: { Text("OK").disabled(isSaveDisabled)}
            }
        }
//        .navigationDestination(isPresented: $lista, destination: {
//            ServicoListaScreen()})
    }
    
    func save()
    {
        let valid = formInfo.manager.triggerValidation()
        if valid
        {
            servico.nome = formInfo.nome
            servico.daCategoria = categoria
            viewModel.update(servico: servico)
        }
    }
}
