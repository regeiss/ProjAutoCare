//
//  VeiculoScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 01/07/23.
//
import SwiftUI
import CoreData
import FormValidator

enum VeiculoFocusable: Hashable
{
    case nome
    case marca
    case modelo
    case placa
    case chassis
    case ano
}

class VeiculoFormInfo: ObservableObject
{
    @Published var manager = FormManager(validationType: .deferred)
    @FormField(validator: NonEmptyValidator(message: "Preencha este campo!"))
    var nome: String = ""
    lazy var nomeVazio = _nome.validation(manager: manager)
    
    var marca: String = ""
    var modelo: String = ""
    var placa: String = ""
    var chassis: String = ""
    var ano: String = ""
    
    let regexNumerico: String =  "[0-9[\\b]]+"
    
}

@available(iOS 16.0, *)
struct VeiculoScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: VeiculoViewModel
    @ObservedObject var formInfo = VeiculoFormInfo()
    @FocusState private var veiculoInFocus: VeiculoFocusable?
    @State var isSaveDisabled: Bool = true
    
    var veiculo: Veiculo
    var isEdit: Bool
    
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
                if isEdit
                {
                    formInfo.nome = veiculo.nome ?? ""
                    formInfo.marca = veiculo.marca ?? ""
                    formInfo.modelo = veiculo.modelo ?? ""
                    formInfo.placa = veiculo.placa ?? ""
                    formInfo.chassis = veiculo.chassis ?? ""
                    formInfo.ano = String(veiculo.ano)
                }
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
    }
    
    func save()
    {
        let valid = formInfo.manager.triggerValidation()
        if valid
        {
            if isEdit
            {
                veiculo.nome = formInfo.nome
                veiculo.marca = formInfo.marca
                veiculo.modelo = formInfo.modelo
                veiculo.placa = formInfo.placa
                veiculo.chassis = formInfo.chassis
                veiculo.ano = Int16(formInfo.ano) ?? 1990
                viewModel.update(veiculo: veiculo)
            }
            else
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
}
