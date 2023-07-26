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
    @ObservedObject var formInfo = ServicoFormInfo()
    @State private var edicao = false
    
    var servico: Servico
    
    var body: some View
    {
        VStack
        {
            Form
            {
                Section
                {
                    TextField("nome", text: $formInfo.nome)
                }.disabled(true)
            }
            .scrollContentBackground(.hidden)
        }.onAppear
        {
            formInfo.nome = servico.nome ?? ""
            // formInfo.bandeira = servico.bandeira ?? ""
        }
        .background(Color("backGroundColor"))
        .navigationTitle("Serviço")
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
                dismiss()
            }
            label: { Text("OK")}
            }
        }
        .navigationDestination(isPresented: $edicao, destination: {
            ServicoEditScreen(viewModel: viewModel, servico: servico)
        })
    }
}
