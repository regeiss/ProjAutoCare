//
//  AlertaCoordinator.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 07/12/23.
//

import SwiftUI
import SwiftUICoordinator

class AlertaCoordinator: Routing
{
    
    // MARK: - Internal properties
    weak var parent: Coordinator?
    var childCoordinators = [WeakCoordinator]()
    var navigationController: NavigationController
    let startRoute: AlertaRoute
    
    // MARK: - Initialization

    init(
        parent: Coordinator?,
        navigationController: NavigationController,
        startRoute: AlertaRoute = .alerta
    ) {
        self.parent = parent
        self.navigationController = navigationController
        self.startRoute = startRoute
    }
    
    func handle(_ action: CoordinatorAction)
    {
        switch action
        {
        case AlertaAction.alerta:
            try? show(route: .alerta)

        default:
            parent?.handle(action)
        }
    }
}

// MARK: - RouterViewFactory

extension AlertaCoordinator: RouterViewFactory
{
    
    @ViewBuilder
    public func view(for route: AlertaRoute) -> some View
    {
        switch route
        {
        case .alerta:
            AlertaListaScreen<AlertaCoordinator>()
        case .ok:
            EmptyView()
        }
    }
}
