//
//  ServicoEfetuadoEditScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 18/08/23.
//

import SwiftUI 

struct ServicoEfetuadoEditScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ServicoEfetuadoViewModel
    @StateObject var formInfo = ServicoEfetuadoFormInfo()
    @FocusState private var itemServicoInFocus: ServicoEfetuadoFocusable?
    @StateObject private var viewModelServico = ServicoViewModel()
    @StateObject private var viewModelVeiculo = VeiculoViewModel()
    
    @State var isSaveDisabled: Bool = true
    @State var servico: Servico?
    @State var lista = false
    
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
            .onAppear
            {
                servico = servicoEfetuado.doServico
                formInfo.quilometragem = (String(servicoEfetuado.quilometragem).toQuilometrosFormat())
                formInfo.nome = servicoEfetuado.nome ?? ""
                formInfo.data = servicoEfetuado.data ?? Date()
                formInfo.custo = (String(servicoEfetuado.custo).toCurrencyFormat())
                formInfo.observacoes = servicoEfetuado.observacoes ?? ""
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
                lista = true
            }
            label: { Text("OK").disabled(isSaveDisabled)}
            }
        }.navigationDestination(isPresented: $lista, destination: {
            ServicoEfetuadoListaScreen()})
    }
    
    func save()
    {
        let valid = formInfo.manager.triggerValidation()
        
        if valid
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
        
    }
}
