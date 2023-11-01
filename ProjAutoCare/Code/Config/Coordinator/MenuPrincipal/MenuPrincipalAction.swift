//
//  MenuPrincipalAction.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 31/10/23.
//

import Foundation
import SwiftUICoordinator

enum MenuPrincipalAction: CoordinatorAction
{
    case simpleShapes
    case customShapes
    case featuredShape(NavigationRoute)
}
