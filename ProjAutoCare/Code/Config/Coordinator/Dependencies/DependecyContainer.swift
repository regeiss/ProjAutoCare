//
//  DependecyContainer.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 25/10/23.
//

import SwiftUI
import SwiftUICoordinator

@MainActor
final class DependencyContainer 
{
    let factory = NavigationControllerFactory()
    lazy var delegate = factory.makeNavigationDelegate( [FadeTransition()])
    lazy var navigationController = factory.makeNavigationController(delegate: delegate)
    let deepLinkHandler = DeepLinkHandler.shared
    
    private(set) var appCoordinator: AppCoordinator?
    
    func set(_ coordinator: AppCoordinator) 
    {
        guard appCoordinator == nil
        else { return }
        
        self.appCoordinator = coordinator
    }
}

extension DependencyContainer: CoordinatorFactory 
{
    func makeAppCoordinator(window: UIWindow) -> AppCoordinator 
    {
        return AppCoordinator(
            window: window,
            navigationController: self.navigationController
        )
    }
    
    func makeMenuPrincipalCoordinator(parent: Coordinator) -> MenuPrincipalCoordinator 
    {
        return MenuPrincipalCoordinator(
            parent: parent,
            navigationController: self.navigationController,
            factory: self
        )
    }
    
    func makeAbastecimentoCoordinator(parent: Coordinator) -> AbastecimentoCoordinator
    {
        return AbastecimentoCoordinator(
            parent: parent,
            navigationController: self.navigationController
        )
    }
}

extension DependencyContainer 
{
    static let mock = DependencyContainer()
}
