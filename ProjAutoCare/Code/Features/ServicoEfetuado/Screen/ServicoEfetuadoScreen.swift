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
    @Published var manager = FormManager(validationType: .deferred)
    
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
