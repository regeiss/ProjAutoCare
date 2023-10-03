//
//  VeiculoReadScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 24/07/23.
//

import SwiftUI

struct VeiculoReadScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: VeiculoViewModel
    @ObservedObject var formInfo = VeiculoFormInfo()
    @State private var edicao = false
    @State var marca: String = ""
    var veiculo: Veiculo
    
    var body: some View
    {
        VStack
        {
            Form
            {
                Section
                {
                    TextField("nome", text: $formInfo.nome)
                    TextField("marca", text: $marca)
                    TextField("modelo", text: $formInfo.modelo)
                    TextField("placa", text: $formInfo.placa)
                    TextField("chassis", text: $formInfo.chassis)
                    TextField("ano", text: $formInfo.ano)
                }.disabled(true)
            }
            .scrollContentBackground(.hidden)
            .onAppear
            {
                marca = viewModel.buscaMarcaModelo(id: 2)
                formInfo.nome = veiculo.nome ?? ""
                formInfo.modelo = veiculo.nomeModelo
                formInfo.placa = veiculo.placa ?? ""
                formInfo.chassis = veiculo.chassis ?? ""
                formInfo.ano = String(veiculo.ano)
            }
            .background(Color("backGroundColor"))
            .navigationTitle("Veículos")
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
                VeiculoEditScreen(viewModel: viewModel, veiculo: veiculo)
            })
        }
    }
}
