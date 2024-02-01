//
//  PostoCoordinator.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 30/01/24.
//

import SwiftUI
import SwiftUICoordinator

@available(iOS 17.0, *)
class PostoCoordinator: Routing
{
    // MARK: - Internal properties
    weak var parent: Coordinator?
    var childCoordinators = [WeakCoordinator]()
    var navigationController: NavigationController
    let startRoute: PostoRoute
    
    // MARK: - Initialization

    init(
        parent: Coordinator?,
        navigationController: NavigationController,
        startRoute: PostoRoute = .lista
    ) {
        self.parent = parent
        self.navigationController = navigationController
        self.startRoute = startRoute
    }
    
    func handle(_ action: CoordinatorAction)
    {
        switch action
        {
        case PostoAction.lista:
            try? show(route: .lista)
        case PostoAction.leitura:
            try? show(route: .leitura)
        case PostoAction.inclusao:
            try? show(route: .inclusao)
        case PostoAction.edicao:
            try? show(route: .edicao)
        case Action.done(_):
            self.navigationController.dismiss(animated: true)
        default:
            parent?.handle(action)
        }
    }
}

// MARK: - RouterViewFactory

@available(iOS 17.0, *)
extension PostoCoordinator: RouterViewFactory
{
    @ViewBuilder
    public func view(for route: PostoRoute) -> some View
    {
        switch route
        {
        case .lista:
            PostoListaScreen<PostoCoordinator>()
        case .leitura:
            PostoReadScreen<PostoCoordinator>()
        case .inclusao:
            PostoAddScreen<PostoCoordinator>()
        case .edicao:
            PostoEditScreen<PostoCoordinator>()
        }
    }
}
