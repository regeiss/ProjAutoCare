//
//  VeiculoAddScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 24/07/23.
//

import SwiftUI
import CoreData
import FormValidator

struct VeiculoAddScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: VeiculoViewModel
    @ObservedObject var formInfo = VeiculoFormInfo()
    @FocusState private var veiculoInFocus: VeiculoFocusable?
    @State var isSaveDisabled: Bool = true
    
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
    }
    
    func save()
    {
        let valid = formInfo.manager.triggerValidation()
        if valid
        {
            let veiculo = VeiculoDTO(id: UUID(),
                                     nome: formInfo.nome,
                                     marca: formInfo.marca,
                                     modelo: formInfo.modelo,
                                     placa: formInfo.placa,
                                     chassis: formInfo.chassis,
                                     ativo: false,
                                     padrao: false,
                                     ano: Int16(formInfo.ano) ?? 0)
            viewModel.add(veiculo: veiculo)
        }
    }
}
