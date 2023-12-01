//
//  CoordinatorFactory.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 25/10/23.
//

import SwiftUI
import SwiftUICoordinator

@MainActor
protocol CoordinatorFactory 
{
    func makeMenuPrincipalCoordinator(parent: Coordinator) -> MenuPrincipalCoordinator
    func makeAbastecimentoCoordinator(parent: Coordinator) -> AbastecimentoCoordinator
//    func makeServicoCoordinator(parent: Coordinator) -> ServicoCoordinator
}
