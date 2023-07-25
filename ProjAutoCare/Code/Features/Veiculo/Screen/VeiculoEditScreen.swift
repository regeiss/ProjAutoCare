//
//  VeiculoEditScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 24/07/23.
//

import SwiftUI

struct VeiculoEditScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: VeiculoViewModel
    @StateObject var formInfo = VeiculoFormInfo()
    @FocusState private var veiculoInFocus: VeiculoFocusable?
    @State var isSaveDisabled: Bool = true
    @State var lista = false
    
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
                        .validation(formInfo.nomeVazio)
                        .focused($veiculoInFocus, equals: .nome)
                        .onAppear{ DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {self.veiculoInFocus = .nome}}
                    TextField("marca", text: $formInfo.marca)
                    TextField("modelo", text: $formInfo.modelo)
                    TextField("placa", text: $formInfo.placa)
                    TextField("chassis", text: $formInfo.chassis)
                    TextField("ano", text: $formInfo.ano)
                }
            }
            .scrollContentBackground(.hidden)
            .onReceive(formInfo.manager.$allValid) { isValid in
                self.isSaveDisabled = !isValid}
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
                    save()
                    dismiss()
                }
                label: { Text("OK").disabled(isSaveDisabled)}
                }
            }
        }
        .navigationDestination(isPresented: $lista, destination: {
            VeiculoListaScreen()
        })
    }
    
    func save()
    {
        let valid = formInfo.manager.triggerValidation()
        if valid
        {
                veiculo.nome = formInfo.nome
                veiculo.marca = formInfo.marca
                veiculo.modelo = formInfo.modelo
                veiculo.placa = formInfo.placa
                veiculo.chassis = formInfo.chassis
                veiculo.ano = Int16(formInfo.ano) ?? 1990
                viewModel.update(veiculo: veiculo)
        }
    }
}
