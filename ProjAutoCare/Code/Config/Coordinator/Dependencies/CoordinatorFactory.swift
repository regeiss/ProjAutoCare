//
//  CoordinatorFactory.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 25/10/23.
//

import SwiftUI
import SwiftUICoordinator

@available(iOS 17.0, *)
@MainActor
protocol CoordinatorFactory 
{
    func makeMenuPrincipalCoordinator(parent: Coordinator) -> MenuPrincipalCoordinator
    func makeAbastecimentoCoordinator(parent: Coordinator) -> AbastecimentoCoordinator
    func makeServicoCoordinator(parent: Coordinator) -> ServicoCoordinator
    func makeRelatorioCoordinator(parent: Coordinator) -> RelatorioCoordinator
    func makeCadastroCoordinator(parent: Coordinator) -> CadastroCoordinator
    func makeAlertaCoordinator(parent: Coordinator) -> AlertaCoordinator
}
