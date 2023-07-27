//
//  PostoViewModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 26/06/23.
//

import SwiftUI
import FormValidator

enum PostoFocusable: Hashable
{
    case nome
    case logo
}

class PostoFormInfo: ObservableObject
{
    @Published var manager = FormManager(validationType: .deferred)
    @FormField(validator: NonEmptyValidator(message: "Preencha este campo!"))
    var nome: String = ""
    lazy var nomeVazio = _nome.validation(manager: manager)
    
    @FormField(validator: NonEmptyValidator(message: "Preencha este campo!"))
    var bandeira: String = ""
    lazy var bandeiraVazio = _bandeira.validation(manager: manager)
}
