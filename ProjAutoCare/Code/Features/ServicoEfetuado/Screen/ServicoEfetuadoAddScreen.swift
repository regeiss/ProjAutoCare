//
//  ServicoEfetuadoAddScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 18/08/23.
//

import SwiftUI

struct ServicoEfetuadoAddScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ServicoEfetuadoViewModel
    @ObservedObject var formInfo = ServicoEfetuadoFormInfo()
    @FocusState private var itemServicoInFocus: ServicoEfetuadoFocusable?
    @StateObject private var viewModelServico = ServicoViewModel()
    @StateObject private var viewModelVeiculo = VeiculoViewModel()
    @StateObject private var viewModelRegistro = RegistroViewModel()
    
    @State var isSaveDisabled: Bool = true
    @State var servico: Servico?
    
    var appState = AppState.shared
    
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
                            servico = viewModelServico.servicoLista.first
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
            }
            .scrollContentBackground(.hidden)
            .onReceive(formInfo.manager.$allValid) { isValid in
                self.isSaveDisabled = !isValid}
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
            
            let servicoEfetuado = ServicoEfetuadoDTO(id: UUID(),
                                                     quilometragem: (Int32(formInfo.quilometragem) ?? 0),
                                                     data: formInfo.data,
                                                     nome: formInfo.nome,
                                                     custo: (Double(formInfo.custo) ?? 0),
                                                     observacoes: formInfo.observacoes,
                                                     doServico: servico!,
                                                     doVeiculo: appState.veiculoAtivo!)
            viewModel.add(servicoEfetuado: servicoEfetuado)
            
            let registro = RegistroDTO(id: UUID(), data: Date(), tipo: "SE", idTipo: servicoEfetuado.id)
            viewModelRegistro.add(registro: registro)
        }
    }
}
