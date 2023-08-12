//
//  AbastecimentoScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/06/23.
//

import SwiftUI
import FormValidator

enum AbastecimentoFocusable: Hashable
{
    case quilometragem
    case data
    case litros
    case valorLitro
    case completo
}

class AbastecimentoFormInfo: ObservableObject
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
    
    @Published var litros: String = ""
    @Published var valorLitro: String = ""
    var completo: Bool = false
    
    let regexNumerico: String =  "[0-9[\\b]]+"
}
