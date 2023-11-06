//
//  MenuPrincipalRoute.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 31/10/23.
//

import Foundation
import SwiftUICoordinator

enum MenuPrincipalRoute: NavigationRoute
{
    case abastecimento
    case servico
    case relatorios
    case alertas
    case cadastros
    case dashboard
    case menuPrincipal
    
    var title: String?
    {
        switch self
        {
        case .abastecimento:
            return "SwiftUI Shapes"
        default:
            return nil
        }
    }
    
    var action: TransitionAction?
    {
        switch self
        {
        case .abastecimento:
            // We have to pass nil for the route presenting a child coordinator.
            return nil
        default:
            return .push(animated: true)
        }
    }
}
