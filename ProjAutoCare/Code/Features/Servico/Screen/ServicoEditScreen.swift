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
    @ObservedObject var formInfo = ServicoFormInfo()
    @FocusState private var servicoInFocus: ServicoFocusable?
    @State var isSaveDisabled: Bool = true
    @State var lista = false
    
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
                        .autocorrectionDisabled(true)
                        .validation(formInfo.nomeVazio)
                        .focused($servicoInFocus, equals: .nome)
                        .onAppear{ DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {self.servicoInFocus = .nome}}
                }
            }
            .scrollContentBackground(.hidden)
            .onReceive(formInfo.manager.$allValid) { isValid in
                self.isSaveDisabled = !isValid}
        }.onAppear
        {
            formInfo.nome = servico.nome ?? ""
//                formInfo.bandeira = servico.bandeira ?? ""
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
                save()
                lista = true
            }
            label: { Text("OK").disabled(isSaveDisabled)}
            }
        }
        .navigationDestination(isPresented: $lista, destination: {
            ServicoListaScreen()})
    }
    
    func save()
    {
        let valid = formInfo.manager.triggerValidation()
        if valid
        {
            servico.nome = formInfo.nome
            // servico.bandeira = formInfo.bandeira
            viewModel.update(servico: servico)
        }
    }
}
