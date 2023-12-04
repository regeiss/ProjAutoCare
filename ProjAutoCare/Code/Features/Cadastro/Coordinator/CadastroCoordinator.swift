//
//  CadastroCoordinator.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 03/12/23.
//

import SwiftUI
import SwiftUICoordinator

class CadastroCoordinator: Routing
{
    // MARK: - Internal properties
    weak var parent: Coordinator?
    var childCoordinators = [WeakCoordinator]()
    var navigationController: NavigationController
    let startRoute: CadastroRoute
    
    // MARK: - Initialization
    
    init(
        parent: Coordinator?,
        navigationController: NavigationController,
        startRoute: CadastroRoute = .lista
    ) {
        self.parent = parent
        self.navigationController = navigationController
        self.startRoute = startRoute
    }
    
    func handle(_ action: CoordinatorAction)
    {
        switch action
        {
        case CadastroAction.lista:
            try? show(route: .lista)
        case CadastroAction.categoria:
            try? show(route: .categoria)
        case CadastroAction.marca:
            try? show(route: .marca)
        case CadastroAction.modelo:
            try? show(route: .modelo)
        case CadastroAction.perfil:
            try? show(route: .perfil)
        case CadastroAction.posto:
            try? show(route: .posto)
        case CadastroAction.servico:
            try? show(route: .servico)
        case CadastroAction.veiculo:
            try? show(route: .veiculo)
        default:
            parent?.handle(action)
        }
    }
}

extension CadastroCoordinator: RouterViewFactory
{
    @ViewBuilder
    public func view(for route: CadastroRoute) -> some View
    {
        switch route
        {
        case .lista:
            CadastroListaScreen<CadastroCoordinator>()
        case .categoria:
            CadastroListaScreen<CadastroCoordinator>()
        case .marca:
            CadastroListaScreen<CadastroCoordinator>()
        case .modelo:
            CadastroListaScreen<CadastroCoordinator>()
        case .perfil:
            CadastroListaScreen<CadastroCoordinator>()
        case .posto:
            CadastroListaScreen<CadastroCoordinator>()
        case .servico:
            CadastroListaScreen<CadastroCoordinator>()
        case .veiculo:
            CadastroListaScreen<CadastroCoordinator>()
        }
    }
}
