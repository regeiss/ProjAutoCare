//
//  AbastecimentoCoordinator.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 08/11/23.
//

import SwiftUI
import SwiftUICoordinator

class AbastecimentoCoordinator: Routing
{
    // MARK: - Internal properties
    weak var parent: Coordinator?
    var childCoordinators = [WeakCoordinator]()
    var navigationController: NavigationController
    let startRoute: AbastecimentoRoute
    
    // MARK: - Initialization

    init(
        parent: Coordinator?,
        navigationController: NavigationController,
        startRoute: AbastecimentoRoute = .lista
    ) {
        self.parent = parent
        self.navigationController = navigationController
        self.startRoute = startRoute
    }
    
    func handle(_ action: CoordinatorAction) 
    {
        switch action 
        {
        case AbastecimentoAction.lista:
            try? show(route: .lista)
        case AbastecimentoAction.leitura:
            try? show(route: .leitura)
        case AbastecimentoAction.inclusao:
            try? show(route: .inclusao)
        case AbastecimentoAction.edicao:
            try? show(route: .edicao)

        default:
            parent?.handle(action)
        }
    }
}

// MARK: - RouterViewFactory

extension AbastecimentoCoordinator: RouterViewFactory 
{
    @ViewBuilder
    public func view(for route: AbastecimentoRoute) -> some View
    {
        switch route 
        {
        case .lista:
            AbastecimentoListaScreen<AbastecimentoCoordinator>()
        case .leitura:
            AbastecimentoListaScreen<AbastecimentoCoordinator>()
        case .inclusao:
            AbastecimentoListaScreen<AbastecimentoCoordinator>()
        case .edicao:
            AbastecimentoListaScreen<AbastecimentoCoordinator>()
        }
    }
}
