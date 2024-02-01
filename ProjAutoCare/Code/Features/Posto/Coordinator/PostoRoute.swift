//
//  PostoRoute.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 30/01/24.
//

import Foundation
import SwiftUICoordinator

enum PostoRoute: NavigationRoute
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
            return "Posto"
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
