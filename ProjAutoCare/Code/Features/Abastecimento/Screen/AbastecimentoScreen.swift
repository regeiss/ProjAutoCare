//
//  AbastecimentoScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/06/23.
//

import SwiftUI

enum AbastecimentoFocusable: Hashable
{
    case kms
    case data
    case litros
    case valorLitro
    case completo
}

class AbastecimentoFormInfo: ObservableObject
{
    @StateObject private var viewModel = AbastecimentoAction()
    
    @Published var kms: String = ""
    @Published var data: Date = Date()
    @Published var litros: String = ""
    @Published var valorLitro: String = ""
    @Published var completo: Bool = false
    
    let regexNumerico: String =  "[0-9[\\b]]+"
    
    //    lazy var form = { FormValidation(validationType: .deferred)}()
    //    lazy var valKMVazio: ValidationContainer = { $km.nonEmptyValidator(form: form, errorMessage: "km deve ser informada")}()
    //    lazy var valKMNumerico: ValidationContainer = { $km.patternValidator(form: form, pattern: regexNumerico, errorMessage: "km deve ser númerica")}()
    //    lazy var valLitros: ValidationContainer = { $litros.nonEmptyValidator(form: form, errorMessage: "qtd litros deve ser informada")}()
    //    lazy var valLitrosNumerico: ValidationContainer = { $litros.patternValidator(form: form, pattern: regexNumerico, errorMessage: "qtd litros deve ser númerica")}()
    //    lazy var valValorLitro: ValidationContainer = { $valorLitro.nonEmptyValidator(form: form, errorMessage: "valor deve ser informado")}()
    //    lazy var valValorNumerico: ValidationContainer = { $valorLitro.patternValidator(form: form, pattern: regexNumerico, errorMessage: "valor litro deve ser númerico")}()
    //    lazy var dataAbastecimento: ValidationContainer = { $data.dateValidator(form: form, before: Date(), errorMessage: "data não pode ser maior que hoje")}()
}

@available(iOS 16.0, *)struct AbastecimentoScreen: View
{
    @ObservedObject var formInfo = AbastecimentoFormInfo()
    @FocusState private var abastecimentoInFocus: AbastecimentoFocusable?
    
    var abastecimento: AbastecimentoModel
    var isEdit: Bool
    
    private var valorTotal: String
    {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let total = (Double(formInfo.litros) ?? 0) * (Double(formInfo.valorLitro) ?? 0)
        
        return formatter.string(from: NSNumber(value: total)) ?? "$0"
    }
    
    var body: some View
    {
        VStack
        {
            Form
            {
                Section
                {
                    TextField("km", text: $formInfo.kms)
                    //                             .validation(formInfo.valKMVazio)
                    //                             .validation(formInfo.valKMNumerico)
                        .focused($abastecimentoInFocus, equals: .kms)
                        .keyboardType(.numbersAndPunctuation)
                        .onAppear{ DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {self.abastecimentoInFocus = .kms}}
                    DatePicker("data", selection: $formInfo.data)
                        .frame(maxHeight: 400)
                        .focused($abastecimentoInFocus, equals: .data)
                    //                            .validation(formInfo.dataAbastecimento)
                    TextField("litros", text: $formInfo.litros)
                    //                             .validation(formInfo.valLitros)
                    //                             .validation(formInfo.valLitrosNumerico)
                    //                             .focused($abastecimentoInFocus, equals: .litros)
                        .keyboardType(.numbersAndPunctuation)
                    TextField("valor litro", text: $formInfo.valorLitro)
                    //                             .validation(formInfo.valValorLitro)
                    //                             .validation(formInfo.valValorNumerico)
                        .focused($abastecimentoInFocus, equals: .litros)
                        .keyboardType(.numbersAndPunctuation)
                    Text("Valor total \(valorTotal)")
                    Toggle(isOn: $formInfo.completo)
                    {
                        Text("completo")
                    }.focused($abastecimentoInFocus, equals: .completo)
                    
                    //                         Picker("Posto:", selection: $posto)
                    //                         {
                    //                             Text("Nenhum").tag(Posto?.none)
                    //                             ForEach(viewModelPosto.postosLista) { (posto: Posto) in
                    //                                 Text(posto.nome!).tag(posto as Posto?)
                    //                             }
                    //                         }.pickerStyle(.automatic)
                }
            }.scrollContentBackground(.hidden)
            // .onReceive(pub)  {_ in gravarAbastecimento()}
        }
        .background(Color("backGroundMain"))
        .navigationTitle("Abastecimento")
        .navigationBarTitleDisplayMode(.automatic)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading)
            { Button {
                pilot.pop(animated: .random())
            }
                label: { Text("Cancelar")}}
            ToolbarItem(placement: .navigationBarTrailing)
            { Button {
                save()
                pilot.pop(animated: .random())
            }
                label: { Text("OK")}}
        }
        // .onReceive(formInfo.form.$allValid) { isValid in self.isSaveDisabled = !isValid}
        
    }
    func save()
    {
//        let veiculo = Veiculo()
//
//        veiculo.name = formInfo.nome
//        veiculo.marca = formInfo.marca
//        veiculo.modelo = formInfo.modelo
//        veiculo.ano = Int(formInfo.ano) ?? 0
//        veiculo.placa = formInfo.placa
//        veiculo.chassis = formInfo.chassis
//        veiculo.ativo = false
//        veiculo.padrao = false
//        viewModel.saveObject(veiculo: veiculo, isEdit: isEdit)
    }
}

@available(iOS 16.0, *)
struct AbastecimentoScreen_Previews: PreviewProvider {
    static var previews: some View {
        AbastecimentoScreen(abastecimento: Abastecimento(), isEdit: false)
    }
}


#Preview {
    AbastecimentoScreen()
}
