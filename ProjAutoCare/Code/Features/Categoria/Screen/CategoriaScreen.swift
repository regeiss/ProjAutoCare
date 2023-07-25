//
//  CategoriaScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 09/07/23.
//

import SwiftUI
import CoreData
import FormValidator

enum CategoriaFocusable: Hashable
{
    case nome
}

class CategoriaFormInfo: ObservableObject
{
    @Published var manager = FormManager(validationType: .deferred)
    @FormField(validator: NonEmptyValidator(message: "Preencha este campo!"))
    var nome: String = ""
    lazy var nomeVazio = _nome.validation(manager: manager)
}
