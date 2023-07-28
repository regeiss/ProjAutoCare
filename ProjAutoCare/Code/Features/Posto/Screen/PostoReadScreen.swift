//
//  PostoReadScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 24/07/23.
//

import SwiftUI

struct PostoReadScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: PostoViewModel
    @ObservedObject var formInfo = PostoFormInfo()
    @State private var edicao = false
    
    var posto: Posto
    
    var body: some View
    {
        VStack
        {
            Form
            {
                Section
                {
                    TextField("nome", text: $formInfo.nome).disabled(true)
                    TextField("bandeira", text: $formInfo.bandeira).disabled(true)
                }
            }
            .scrollContentBackground(.hidden)
        }.onAppear
        {
            formInfo.nome = posto.nome ?? ""
            formInfo.bandeira = posto.bandeira ?? ""
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
                
                edicao = true
            }
            label: { Text("Editar")}
            }
        }
        .navigationDestination(isPresented: $edicao, destination: {
            PostoEditScreen(viewModel: viewModel, posto: posto)
        })
    }
}
