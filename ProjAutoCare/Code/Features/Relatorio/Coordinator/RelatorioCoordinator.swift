//
//  RelatorioCoordinator.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 02/12/23.
//

import SwiftUI
import SwiftUICoordinator

class RelatorioCoordinator: Routing
{
    // MARK: - Internal properties
    weak var parent: Coordinator?
    var childCoordinators = [WeakCoordinator]()
    var navigationController: NavigationController
    let startRoute: RelatorioRoute
    
    // MARK: - Initialization
    
    init(
        parent: Coordinator?,
        navigationController: NavigationController,
        startRoute: RelatorioRoute = .lista
    ) {
        self.parent = parent
        self.navigationController = navigationController
        self.startRoute = startRoute
    }

    func handle(_ action: CoordinatorAction)
    {
        switch action
        {
        case RelatorioAction.lista:
            try? show(route: .lista)
        case RelatorioAction.combustivel:
            try? show(route: .combustivel)
        case RelatorioAction.consumo:
            try? show(route: .consumo)
        case RelatorioAction.servico:
            try? show(route: .servico)
        case RelatorioAction.graficos:
            try? show(route: .graficos)
            
        default:
            parent?.handle(action)
        }
    }
    
}

// MARK: - RouterViewFactory
extension RelatorioCoordinator: RouterViewFactory
{
    @ViewBuilder
    public func view(for route: RelatorioRoute) -> some View
    {
        switch route
        {
        case .lista:
            RelatorioListaScreen<RelatorioCoordinator>()
        case .combustivel:
            RelatorioListaScreen<RelatorioCoordinator>()
        case .consumo:
            RelatorioListaScreen<RelatorioCoordinator>()
        case .servico:
            RelatorioListaScreen<RelatorioCoordinator>()
        case .graficos:
            RelatorioListaScreen<RelatorioCoordinator>()
        }
    }
}
