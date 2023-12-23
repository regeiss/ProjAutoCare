//
//  RelatorioRoute.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 02/12/23.
//

import SwiftUI
import SwiftUICoordinator

enum RelatorioRoute: NavigationRoute
{
    case lista
    case combustivel
    case consumo
    case servico
    case graficos
    
    var title: String?
    {
        switch self
        {
        case .lista, .combustivel, .graficos:
            return "Relatórios"
        default:
            return nil
        }
    }
    
    var action: TransitionAction?
    {
        switch self
        {
        case .lista:
            // We have to pass nil for the route presenting a child coordinator.
            // return nil
            return .push(animated: true)
        default:
            return .push(animated: true)
        }
    }
}
