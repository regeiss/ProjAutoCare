//
//  ServicoEfetuadoReadScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 18/08/23.
//

import SwiftUI

struct ServicoEfetuadoReadScreen: View 
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ServicoEfetuadoViewModel
    @ObservedObject var formInfo = ServicoEfetuadoFormInfo()
    @StateObject private var viewModelServico = ServicoViewModel()
    
    @State private var edicao = false
    @State var servico: Servico?
    
    var appState = AppState.shared
    var servicoEfetuado: ServicoEfetuado
    
    var body: some View
    {
        VStack
        {
            Form
            {
                Section
                {
                    Picker("Serviço:", selection: $servico)
                    {
                        ForEach(viewModelServico.servicoLista) { (servico: Servico) in
                            Text(servico.nome!).tag(servico as Servico?)
                        }
                    }.pickerStyle(.automatic)
                        .onAppear {
                            servico = servicoEfetuado.doServico
                        }
                    TextField("km", text: $formInfo.quilometragem)
                    DatePicker("data", selection: $formInfo.data)
                    TextField("nome", text: $formInfo.nome)
                    TextField("custo", text: $formInfo.custo)
                    TextField("observações", text: $formInfo.observacoes)
                }.disabled(true)
            }.scrollContentBackground(.hidden)
                
        }.onAppear
        {
                servico = servicoEfetuado.doServico
                formInfo.quilometragem = (String(servicoEfetuado.quilometragem).toQuilometrosFormat())
                formInfo.nome = servicoEfetuado.nome ?? ""
                formInfo.data = servicoEfetuado.data ?? Date()
                formInfo.custo = (String(servicoEfetuado.custo).toCurrencyFormat())
                formInfo.observacoes = servicoEfetuado.observacoes ?? ""
        }
        .background(Color("backGroundColor"))
        .navigationTitle("Serviço efetuado")
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
            ServicoEfetuadoEditScreen(viewModel: viewModel, servicoEfetuado: servicoEfetuado)
        })
    }
}
