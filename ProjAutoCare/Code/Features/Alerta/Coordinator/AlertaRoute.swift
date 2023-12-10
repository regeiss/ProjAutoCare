//
//  AlertaRoute.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 07/12/23.
//

import SwiftUI
import SwiftUICoordinator

enum AlertaRoute: NavigationRoute
{
    case alerta
    case ok
    
    var title: String?
    {
        switch self
        {
        case .alerta, .ok:
            return "Alertas"
        }
    }
    
    var action: TransitionAction?
    {
        switch self
        {
        case .alerta:
            return .push(animated: true)
            // return .present(delegate: SlideTransitionDelegate())
        case .ok:
            return nil
        }
    }
}
