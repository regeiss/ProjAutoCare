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
        case .lista, .leitura:
            return "Abastecimento"
        default:
            return nil
        }
    }
    
    var action: TransitionAction?
    {
        switch self
        {
        case .leitura:
            // We have to pass nil for the route presenting a child coordinator.
            // return nil
            return .push(animated: true)
        default:
            return .push(animated: true)
        }
    }
}
