//
//  CadastroRoute.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 03/12/23.
//

import Foundation
import SwiftUICoordinator

enum CadastroRoute: NavigationRoute
{
    case lista
    case categoria
    case marca
    case modelo
    case perfil
    case posto
    case servico
    case veiculo
    
    var title: String?
    {
        switch self
        {
        case .lista:
            return "Cadastros"
        default:
            return nil
        }
    }
    
    var action: TransitionAction?
    {
        switch self
        {
        case .lista:
            // We have to pass nil for the route presenting a child coordinator. ??????????????????????
            // return nil
            return .push(animated: true)
        default:
            return .push(animated: true)
        }
    }
}
