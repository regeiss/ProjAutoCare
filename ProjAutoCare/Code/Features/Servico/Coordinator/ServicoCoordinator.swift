//
//  ServicoCoordinator.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 20/11/23.
//

import SwiftUI
import SwiftUICoordinator

class ServicoCoordinator: Routing
{
    // MARK: - Internal properties
    weak var parent: Coordinator?
    var childCoordinators = [WeakCoordinator]()
    var navigationController: NavigationController
    let startRoute: ServicoRoute
    
    init(
        parent: Coordinator?,
        navigationController: NavigationController,
        startRoute: ServicoRoute = .leitura
    ) {
        self.parent = parent
        self.navigationController = navigationController
        self.startRoute = startRoute
    }
    
    func handle(_ action: CoordinatorAction)
    {
        switch action
        {
        case ServicoAction.lista:
            try? show(route: .lista)
        case ServicoAction.leitura:
            try? show(route: .leitura)
        case ServicoAction.inclusao:
            try? show(route: .inclusao)
        case ServicoAction.edicao:
            try? show(route: .edicao)

        default:
            parent?.handle(action)
        }
    }
}

// MARK: - RouterViewFactory

extension ServicoCoordinator: RouterViewFactory
{
    @ViewBuilder
    public func view(for route: ServicoRoute) -> some View
    {
        switch route
        {
        case .lista:
            ServicoListaScreen<ServicoCoordinator>()
        case .leitura:
            ServicoListaScreen<ServicoCoordinator>()
        case .inclusao:
            ServicoListaScreen<ServicoCoordinator>()
        case .edicao:
            ServicoListaScreen<ServicoCoordinator>()
        }
    }
}
