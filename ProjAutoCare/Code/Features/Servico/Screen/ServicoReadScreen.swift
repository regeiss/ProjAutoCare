//
//  ServicoReadScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 24/07/23.
//

import SwiftUI

struct ServicoReadScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ServicoViewModel
    @ObservedObject var viewModelCategoria = CategoriaViewModel()
    @ObservedObject var formInfo = ServicoFormInfo()
    @State private var edicao = false
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
                }.disabled(true)
            }
            .scrollContentBackground(.hidden)
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
                edicao = true 
            }
            label: { Text("Editar")}
            }
        }
        .navigationDestination(isPresented: $edicao, destination: {
            ServicoEditScreen(viewModel: viewModel, servico: servico)
        })
    }
}
