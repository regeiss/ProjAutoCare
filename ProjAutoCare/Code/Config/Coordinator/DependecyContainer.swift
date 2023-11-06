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
    
    let navigationController = NavigationController()
    // let deepLinkHandler = DeepLinkHandler.shared
    
    private(set) var appCoordinator: AppCoordinator?
    
    func set(_ coordinator: AppCoordinator) {
        guard appCoordinator == nil else {
            return
        }
        
        self.appCoordinator = coordinator
    }
}

//extension DependencyContainer: CoordinatorFactory 
//{
//    func makeAppCoordinator(window: UIWindow) -> AppCoordinator 
//    {
//        return AppCoordinator(
//            window: window,
//            navigationController: self.navigationController,
//            transitions: [FadeTransition()]
//        )
//    }
//    
//    func makeMenuPrincipalCoordinator(parent: Coordinator) -> MenuPrincipalCoordinator {
//        return MenuPrincipalCoordinator(
//            parent: parent,
//            navigationController: self.navigationController,
//            factory: self
//        )
//    }
//}

extension DependencyContainer {
    static let mock = DependencyContainer()
}
