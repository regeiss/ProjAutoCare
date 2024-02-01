//
//  DependecyContainer.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 25/10/23.
//

import SwiftUI
import SwiftUICoordinator

@available(iOS 17.0, *)
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

@available(iOS 17.0, *)
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
    
    func makeServicoCoordinator(parent: Coordinator) -> ServicoCoordinator
    {
        return ServicoCoordinator(
            parent: parent,
            navigationController: self.navigationController
        )
    }
    
    func makeRelatorioCoordinator(parent: Coordinator) -> RelatorioCoordinator 
    {
        return RelatorioCoordinator(
            parent: parent,
            navigationController: self.navigationController
        )
    }
    
    func makeCadastroCoordinator(parent: Coordinator) -> CadastroCoordinator
    {
        return CadastroCoordinator(
            parent: parent,
            navigationController: self.navigationController
        )
    }
    
    func makeAlertaCoordinator(parent: Coordinator) -> AlertaCoordinator
    {
        return AlertaCoordinator(
            parent: parent,
            navigationController: self.navigationController
        )
    }
}

@available(iOS 17.0, *)
extension DependencyContainer 
{
    static let mock = DependencyContainer()
}
