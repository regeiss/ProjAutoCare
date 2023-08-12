//
//  ServicoEfetuadoScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 14/07/23.
//

import SwiftUI
import FormValidator

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
    
    @DateFormField(message: "Date can not be in the future!")
    var data: Date = Date()
    lazy var validacaoData = _data.validation(manager: manager, before: Date())
    
    @FormField(validator: NonEmptyValidator(message: "Preencha este campo!"))
    var nome: String = ""
    lazy var nomeVazio = _nome.validation(manager: manager)
    
    @FormField(validator: {
         CompositeValidator(
                 validators: [
                     NonEmptyValidator(message: "Preencha este campo!"),
                     PatternValidator(pattern: AppState.shared.regexNumerico, message: "Deve ser númerico")
                 ],
                 type: .all,
                 strategy: .all)
    })
    var custo: String = ""
    lazy var custoNaoInformado = _custo.validation(manager: manager)
    
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
    var isAdd: Bool
    
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
                            if isAdd
                            {servico = viewModelServico.servicoLista.first}
                        }
                    TextField("km", text: $formInfo.quilometragem)
                        .keyboardType(.numbersAndPunctuation)
                        .focused($itemServicoInFocus, equals: .quilometragem)
                        .onAppear{ DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) { self.itemServicoInFocus = .quilometragem}}
                        .validation(formInfo.kmNaoInformado)
                    DatePicker("data", selection: $formInfo.data)
                        .frame(maxHeight: 400)
                        .validation(formInfo.validacaoData)
                    TextField("nome", text: $formInfo.nome)
                        .validation(formInfo.nomeVazio)
                    TextField("custo", text: $formInfo.custo)
                        .keyboardType(.numbersAndPunctuation)
                        .validation(formInfo.custoNaoInformado)
                    TextField("observações", text: $formInfo.observacoes)
                }
            }.scrollContentBackground(.hidden)
                .onReceive(formInfo.manager.$allValid) { isValid in
                    self.isSaveDisabled = !isValid}
        }.onAppear
        {
            if isEdit
            {
                servico = servicoEfetuado.doServico
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
                servicoEfetuado.doServico = servico
                servicoEfetuado.quilometragem = Int32(formInfo.quilometragem) ?? 0
                servicoEfetuado.data = formInfo.data
                servicoEfetuado.nome = formInfo.nome
                servicoEfetuado.custo = (Double(formInfo.custo) ?? 0)
                servicoEfetuado.observacoes = formInfo.observacoes
                servicoEfetuado.doVeiculo = appState.veiculoAtivo!
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
