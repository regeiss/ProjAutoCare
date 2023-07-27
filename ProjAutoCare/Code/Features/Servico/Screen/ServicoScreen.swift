//
//  ServicoScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 02/07/23.
//

import SwiftUI
import CoreData
import FormValidator

enum ServicoFocusable: Hashable
{
    case nome
}

class ServicoFormInfo: ObservableObject
{
    @Published var manager = FormManager(validationType: .deferred)
    @FormField(validator: NonEmptyValidator(message: "Preencha este campo!"))
    var nome: String = ""
    lazy var nomeVazio = _nome.validation(manager: manager)
    
    //        @FormField(validator: NonEmptyValidator(message: "Preencha este campo!"))
    //        var bandeira: String = ""
    //        lazy var bandeiraVazio = _bandeira.validation(manager: manager)
}
