//
//  VeiculoReadScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 24/07/23.
//

import SwiftUI
import CoreData

struct VeiculoReadScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: VeiculoViewModel
    @ObservedObject var formInfo = VeiculoFormInfo()
    @State private var edicao = false
    
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
                    TextField("marca", text: $formInfo.marca)
                    TextField("modelo", text: $formInfo.modelo)
                    TextField("placa", text: $formInfo.placa)
                    TextField("chassis", text: $formInfo.chassis)
                    TextField("ano", text: $formInfo.ano)
                }.disabled(true)
            }
            .scrollContentBackground(.hidden)
            .onAppear
            {
                formInfo.nome = veiculo.nome ?? ""
                formInfo.marca = veiculo.marca ?? ""
                formInfo.modelo = veiculo.modelo ?? ""
                formInfo.placa = veiculo.placa ?? ""
                formInfo.chassis = veiculo.chassis ?? ""
                formInfo.ano = String(veiculo.ano)
            }
            .background(Color("backGroundColor"))
            .navigationTitle("Veículos")
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
                VeiculoEditScreen(viewModel: viewModel, veiculo: veiculo)
            })
        }
    }
}
