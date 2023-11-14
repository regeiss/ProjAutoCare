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
    let factory: CoordinatorFactory
    
    // MARK: - Initialization

    init(
        parent: Coordinator?,
        navigationController: NavigationController,
        startRoute: AbastecimentoRoute = .leitura,
        factory: CoordinatorFactory
    ) {
        self.parent = parent
        self.navigationController = navigationController
        self.startRoute = startRoute
        self.factory = factory
    }
    
    func handle(_ action: CoordinatorAction) 
    {
//        switch action {
//        case AbastecimentoAction.rect:
//            try? show(route: .rect)
//        case AbastecimentoAction.roundedRect:
//            try? show(route: .roundedRect)
//        case AbastecimentoAction.capsule:
//            try? show(route: .capsule)
//        case AbastecimentoAction.ellipse:
//            try? show(route: .ellipse)
//        case AbastecimentoAction.circle:
//            try? show(route: .circle)
//        default:
//            parent?.handle(action)
//        }
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
