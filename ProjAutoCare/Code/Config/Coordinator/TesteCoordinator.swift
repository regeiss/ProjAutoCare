//
//  TesteCoordinator.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 12/11/23.
//

import Foundation
import SwiftUI
import SwiftUICoordinator

class TesteCoordinator: Routing
{
    var startRoute: AbastecimentoRoute
    weak var parent: Coordinator?
    var childCoordinators: [SwiftUICoordinator.WeakCoordinator] = []
    let factory: CoordinatorFactory
    
    init(
            parent: Coordinator?,
            navigationController: NavigationController,
            startRoute: AbastecimentoRoute = .lista,
            factory: CoordinatorFactory
        ) {
            self.parent = parent
            self.navigationController = navigationController
            self.startRoute = startRoute
            self.factory = factory
        }
    
    func show(route: AbastecimentoRoute) throws {
        //
    }
    
    func set(routes: [AbastecimentoRoute], animated: Bool) {
        //
    }
    
    func append(routes: [AbastecimentoRoute], animated: Bool) {
        //
    }
    

    
    func handle(_ action: SwiftUICoordinator.CoordinatorAction) {
        //
    }
    
    typealias Route = AbastecimentoRoute
    
    var navigationController: SwiftUICoordinator.NavigationController
    
    func start() throws {
        //
    }
    
    func pop(animated: Bool) {
        //
    }
    
    func popToRoot(animated: Bool) {
        //
    }
    
    func dismiss(animated: Bool) {
        //
    }
    
    
}
extension TesteCoordinator: RouterViewFactory
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
