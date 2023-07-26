//
//  PerfilReadScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 24/07/23.
//

import SwiftUI

struct PerfilReadScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: PerfilViewModel
    @ObservedObject var formInfo = PerfilFormInfo()
    @State var edicao = false
    
    var perfil: Perfil
    
    var body: some View
    {
        VStack(alignment: .leading)
        {
            Form
            {
                Section
                {
                    TextField("nome", text: $formInfo.nome)
                    TextField("email", text: $formInfo.email)
                }.disabled(true)
            }
            .scrollContentBackground(.hidden)
            
        }.onAppear
        {
            formInfo.nome = perfil.nome ?? ""
            formInfo.email = perfil.email ?? ""
        }
        .background(Color("backGroundColor"))
        .navigationTitle("Perfis")
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
                edicao = true
            }
            label: { Text("Editar")}
            }
        }
        .navigationDestination(isPresented: $edicao, destination: {
            PerfilEditScreen(viewModel: viewModel, perfil: perfil)
        })
    }
    
}
