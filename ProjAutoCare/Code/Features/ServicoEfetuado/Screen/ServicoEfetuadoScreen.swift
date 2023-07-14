//
//  ServicoEfetuadoScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 14/07/23.
//

import SwiftUI
import CoreData
import FormValidator

enum ServicoEfetuadoFocusable: Hashable
{
    case idservico
    case idcarro
    case quilometragem
    case data
    case nome
    case custo
    case observacoes
}

class ServicoEfetuadoFormInfo: ObservableObject
{
    @Published var manager = FormManager(validationType: .deferred)
    @FormField(validator: NonEmptyValidator(message: "Preencha este campo!"))
    var nome: String = ""
    lazy var nomeVazio = _nome.validation(manager: manager)
    
    var idservico: UUID = UUID()
    var idcarro: UUID = UUID()
    var quilometragem: String = ""
    var data: Date = Date()
    // var nome: String = ""
    var custo: String = ""
    var observacoes: String = ""
    
    let regexNumerico: String =  "[0-9[\\b]]+"
}

@available(iOS 16.0, *)
struct ServicoEfetuadoScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ServicoEfetuadoViewModel
    @ObservedObject var formInfo = ServicoEfetuadoFormInfo()
    @FocusState private var itemServicoInFocus: ServicoEfetuadoFocusable?
    @StateObject private var viewModelServico = ServicoViewModel()
    
    @State var isSaveDisabled: Bool = true
    @State var servico: Servico?
    
    var servicoEfetuado: ServicoEfetuado
    var isEdit: Bool
    
    var body: some View
    {
        NavigationView
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
                        // .onAppear() { servico = pservico?.id}
                        TextField("km", text: $formInfo.quilometragem)
                            .keyboardType(.numbersAndPunctuation)
                            .focused($itemServicoInFocus, equals: .quilometragem)
                            .onAppear{ DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {self.itemServicoInFocus = .quilometragem}}
                        // .validation(formInfo.valValorNumerico)
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
                    formInfo.nome = servicoEfetuado.nome ?? ""
                    //                formInfo.bandeira = servico.bandeira ?? ""
                }
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
                    dismiss()
                }
                label: { Text("OK").disabled(isSaveDisabled)}
                }
            }
        }
    }
    
    private func gravarItemServico()
    {

    }
    
    func save()
    {
        let valid = formInfo.manager.triggerValidation()
        if valid
        {
            if isEdit
            {
                servicoEfetuado.nome = formInfo.nome
                // servico.bandeira = formInfo.bandeira
                viewModel.update(servicoEfetuado: servicoEfetuado)
            }
            else
            {
                let servicoEfetuado = ServicoEfetuadoDTO(id: UUID(),
                                                     idcarro: formInfo.idcarro,
                                                     quilometragem: (Int32(formInfo.quilometragem) ?? 0),
                                                     data: formInfo.data,
                                                     nome: formInfo.nome,
                                                     custo: (Double(formInfo.custo) ?? 0),
                                                     observacoes: formInfo.observacoes,
                                                   doServico: servico!)
                viewModel.add(servicoEfetuado: servicoEfetuado)
            }
        }
    }
}
