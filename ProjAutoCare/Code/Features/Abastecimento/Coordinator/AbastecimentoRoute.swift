//
//  AbastecimentoRoute.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 08/11/23.
//

import SwiftUI
import SwiftUICoordinator

enum AbastecimentoRoute: NavigationRoute
{
    case leitura
    case lista
    case inclusao
    case edicao
    
    var title: String?
    {
        switch self
        {
        case .lista, .inclusao, .leitura, .edicao:
            return "Abastecimento"
        }
    }
    
    var action: TransitionAction?
    {
        switch self
        {
        default:
            return .push(animated: true)
        }
    }
}
