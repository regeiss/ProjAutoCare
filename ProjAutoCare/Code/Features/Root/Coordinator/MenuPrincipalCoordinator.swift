//
//  MenuPrincipalCoordinator.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 31/10/23.
//

import SwiftUI
import SwiftUICoordinator

class MenuPrincipalCoordinator: Routing
{
    // MARK: - Internal properties
    
    weak var parent: Coordinator?
    var childCoordinators = [WeakCoordinator]()
    let navigationController: NavigationController
    let startRoute: MenuPrincipalRoute
    let factory: CoordinatorFactory
    
    // MARK: - Initialization

    init(
        parent: Coordinator?,
        navigationController: NavigationController,
        startRoute: MenuPrincipalRoute = .menuPrincipal,
        factory: CoordinatorFactory
    ) {
        self.parent = parent
        self.navigationController = navigationController
        self.startRoute = startRoute
        self.factory = factory
    }
    
    func handle(_ action: CoordinatorAction) 
    {
        switch action {
        case MenuPrincipalAction.abastecimento:
            let coordinator = factory.makeAbastecimentoCoordinator(parent: self)
            try? coordinator.start()
            
        case MenuPrincipalAction.servico:
            let coordinator = factory.makeServicoCoordinator(parent: self)
            try? coordinator.start()
            
        case MenuPrincipalAction.relatorios:
            let coordinator = factory.makeRelatorioCoordinator(parent: self)
            try? coordinator.start()
            
        case MenuPrincipalAction.cadastros:
            let coordinator = factory.makeCadastroCoordinator(parent: self)
            try? coordinator.start()
            
        case MenuPrincipalAction.alertas:
            let coordinator = factory.makeAlertaCoordinator(parent: self)
            try? coordinator.start()
            
        case Action.done(_):
            popToRoot()
            childCoordinators.removeAll()
        default:
            parent?.handle(action)
        }
    }
    
    func handle(_ deepLink: DeepLink, with params: [String: String]) 
    {
//        switch deepLink.route 
//        {
//        case MenuPrincipalRoute.abastecimento:
//            let coordinator = factory.makeAbastecimentoCoordinator(parent: self)
//            try? coordinator.start()
//        default:
//            break
//        }
    }
}

// MARK: - RouterViewFactory

extension MenuPrincipalCoordinator: RouterViewFactory
{    
    @ViewBuilder
    public func view(for route: MenuPrincipalRoute) -> some View 
    {
        switch route
        {
        case .menuPrincipal:
            MenuInicialScreen<MenuPrincipalCoordinator>()
        case .abastecimento:
            /// We are returning an empty view for the route presenting a child coordinator.
            AbastecimentoListaScreen<AbastecimentoCoordinator>()
        case .dashboard:
            EmptyView()
        case .cadastros:
            CadastroListaScreen<CadastroCoordinator>()
        case .servico:
            ServicoListaScreen<ServicoCoordinator>()
        case .relatorios:
            RelatorioListaScreen<RelatorioCoordinator>()
        case .alertas:
            AlertaListaScreen<AlertaCoordinator>()
        }
    }
}
