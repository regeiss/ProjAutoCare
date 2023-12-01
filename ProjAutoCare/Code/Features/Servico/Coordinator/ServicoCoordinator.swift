//
//  ServicoCoordinator.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 20/11/23.
//

import Foundation
import SwiftUICoordinator

//class ServicoCoordinator: Routing
//{
//    // MARK: - Internal properties
//    weak var parent: Coordinator?
//    var childCoordinators = [WeakCoordinator]()
//    var navigationController: NavigationController
//    let startRoute: AbastecimentoRoute
//    //let factory: CoordinatorFactory
//    
//    init(
//        parent: Coordinator?,
//        navigationController: NavigationController,
//        startRoute: AbastecimentoRoute = .leitura
//        //factory: CoordinatorFactory
//    ) {
//        self.parent = parent
//        self.navigationController = navigationController
//        self.startRoute = startRoute
//        //self.factory = factory
//    }
//    
//    func handle(_ action: CoordinatorAction)
//    {
//        switch action
//        {
//        case AbastecimentoAction.lista:
//            try? show(route: .lista)
//        case AbastecimentoAction.leitura:
//            try? show(route: .leitura)
//        case AbastecimentoAction.inclusao:
//            try? show(route: .inclusao)
//        case AbastecimentoAction.edicao:
//            try? show(route: .edicao)
//
//        default:
//            parent?.handle(action)
//        }
//    }
//}
//
//// MARK: - RouterViewFactory
//
//extension ServicoCoordinator: RouterViewFactory
//{
//    @ViewBuilder
//    public func view(for route: AbastecimentoRoute) -> some View
//    {
//        switch route
//        {
//        case .lista:
//            AbastecimentoListaScreen<AbastecimentoCoordinator>()
//        case .leitura:
//            AbastecimentoListaScreen<AbastecimentoCoordinator>()
//        case .inclusao:
//            AbastecimentoListaScreen<AbastecimentoCoordinator>()
//        case .edicao:
//            AbastecimentoListaScreen<AbastecimentoCoordinator>()
//        }
//    }
//}
