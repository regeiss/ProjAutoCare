//
//  CategoriaReadScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 23/07/23.
//

import SwiftUI

struct CategoriaReadScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: CategoriaViewModel
    @ObservedObject var formInfo = CategoriaFormInfo()
    @State var edicao = false
    
    var categoria: Categoria
    
    var body: some View
    {
        VStack
        {
            Form
            {
                Section
                {
                    TextField("nome", text: $formInfo.nome).disabled(true)
                }
            }
            .scrollContentBackground(.hidden)
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
                edicao = true
                
            }
            label: { Text("Editar")}
            }
        }
        .navigationDestination(isPresented: $edicao, destination: {
            CategoriaEditScreen(viewModel: viewModel, categoria: categoria)
        })
    }
}
