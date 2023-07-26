//
//  PerfilScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 16/06/23.
//

import SwiftUI
import CoreData
import FormValidator

enum PerfilFocusable: Hashable
{
    case nome
    case email
    case ativo
}

class PerfilFormInfo: ObservableObject
{
    @Published var manager = FormManager(validationType: .deferred)
    @FormField(validator: NonEmptyValidator(message: "Preencha este campo!"))
    var nome: String = ""
    lazy var nomeVazio = _nome.validation(manager: manager)
    
    @FormField(validator: EmailValidator(message: "Informe um email válido!"))
    var email: String = ""
    lazy var emailInvalido = _email.validation(manager: manager)
}
