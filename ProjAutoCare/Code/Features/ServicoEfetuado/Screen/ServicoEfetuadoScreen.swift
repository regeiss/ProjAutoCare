//
//  ServicoEfetuadoScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 14/07/23.
//

import Foundation
import SwiftUI
import CoreData
import FormValidator

enum Regex: String {
    case password = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
    case email = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
    case numeric = "[0-9[\\b]]+"
}

enum ServicoEfetuadoFocusable: Hashable
{
    case idservico
    case quilometragem
    case data
    case nome
    case custo
    case observacoes
}

class ServicoEfetuadoFormInfo: ObservableObject
{
    @Published var manager = FormManager(validationType: .immediate)
    
    @FormField(validator: {
         CompositeValidator(
                 validators: [
                     NonEmptyValidator(message: "Preencha este campo!"),
                     CountValidator(count: 6, type: .greaterThanOrEquals, message: "Tamanho minímo 6."),
                     PatternValidator(pattern: AppState.shared.regexNumerico, message: "Deve ser númerico")
                 ],
                 type: .all,
                 strategy: .all)
    })
    
    var quilometragem: String = ""
    lazy var kmNaoInformado = _quilometragem.validation(manager: manager)
    
    var idservicoEfetuado: UUID = UUID()
    var data: Date = Date()
    var nome: String = ""
    var custo: String = ""
    var observacoes: String = ""
}

@available(iOS 16.0, *)
struct ServicoEfetuadoScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ServicoEfetuadoViewModel
    @ObservedObject var formInfo = ServicoEfetuadoFormInfo()
    @FocusState private var itemServicoInFocus: ServicoEfetuadoFocusable?
    @StateObject private var viewModelServico = ServicoViewModel()
    @StateObject private var viewModelVeiculo = VeiculoViewModel()
    
    @State var isSaveDisabled: Bool = true
    @State var servico: Servico?
    
    var appState = AppState.shared
    var servicoEfetuado: ServicoEfetuado
    var isEdit: Bool
    
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
                        .onAppear { servico = viewModelServico.servicoLista.first}
                    TextField("km", text: $formInfo.quilometragem)
                        .keyboardType(.numbersAndPunctuation)
                        .focused($itemServicoInFocus, equals: .quilometragem)
                        .onAppear{ DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {self.itemServicoInFocus = .quilometragem}}
                        .validation(formInfo.kmNaoInformado)
                    DatePicker("data", selection: $formInfo.data)
                        .frame(maxHeight: 400)
                    TextField("nome", text: $formInfo.nome)
                    // .validation(formInfo.valNomeVazio)
                    TextField("custo", text: $formInfo.custo)
                    //  .validation(formInfo.validacaoCusto)
                    //     .validation(formInfo.valValorNumerico)
                        .keyboardType(.numbersAndPunctuation)
                    TextField("observações", text: $formInfo.observacoes)
                }
            }.scrollContentBackground(.hidden)
                .onReceive(formInfo.manager.$allValid) { isValid in
                    self.isSaveDisabled = !isValid}
        }.onAppear
        {
            if isEdit
            {
                
                formInfo.quilometragem = (String(servicoEfetuado.quilometragem).toQuilometrosFormat())
                formInfo.nome = servicoEfetuado.nome ?? ""
                formInfo.data = servicoEfetuado.data ?? Date()
                formInfo.custo = (String(servicoEfetuado.custo).toCurrencyFormat())
                formInfo.observacoes = servicoEfetuado.observacoes ?? ""
                
            }
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
                save()
                dismiss()
            }
            label: { Text("OK").disabled(isSaveDisabled)}
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
                servicoEfetuado.quilometragem = Int32(formInfo.quilometragem) ?? 0
                servicoEfetuado.data = formInfo.data
                servicoEfetuado.nome = formInfo.nome
                servicoEfetuado.custo = (Double(formInfo.custo) ?? 0)
                servicoEfetuado.observacoes = formInfo.observacoes
                viewModel.update(servicoEfetuado: servicoEfetuado)
            }
            else
            {
                let servicoEfetuado = ServicoEfetuadoDTO(id: UUID(),
                                                         quilometragem: (Int32(formInfo.quilometragem) ?? 0),
                                                         data: formInfo.data,
                                                         nome: formInfo.nome,
                                                         custo: (Double(formInfo.custo) ?? 0),
                                                         observacoes: formInfo.observacoes,
                                                         doServico: servico!,
                                                         doVeiculo: appState.veiculoAtivo!)
                viewModel.add(servicoEfetuado: servicoEfetuado)
            }
        }
    }
}
