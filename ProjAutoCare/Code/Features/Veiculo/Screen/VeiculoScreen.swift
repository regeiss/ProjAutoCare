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
