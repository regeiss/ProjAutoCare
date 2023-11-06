////
////  MenuPrincipalCoordinator.swift
////  ProjAutoCare
////
////  Created by Roberto Edgar Geiss on 31/10/23.
////
//
//import SwiftUI
//import SwiftUICoordinator
//
//class MenuPrincipalCoordinator: Routing 
//{
//
//    // MARK: - Internal properties
//    
//    weak var parent: Coordinator?
//    var childCoordinators = [WeakCoordinator]()
//    let navigationController: NavigationController
//    let startRoute: MenuPrincipalRoute
//    let factory: CoordinatorFactory
//
//    // MARK: - Initialization
//
//    init(
//        parent: Coordinator?,
//        navigationController: NavigationController,
//        startRoute: MenuPrincipalRoute = .menuPrincipal,
//        factory: CoordinatorFactory
//    ) {
//        self.parent = parent
//        self.navigationController = navigationController
//        self.startRoute = startRoute
//        self.factory = factory
//    }
//    
//    func handle(_ action: CoordinatorAction) {
//        switch action {
//        case MenuPrincipalAction.abastecimento:
//            let coordinator = factory.makeMenuPrincipalCoordinator(parent: self)
//            try? coordinator.start()
//        case ShapesAction.customShapes:
//            let coordinator = factory.makeCustomShapesCoordinator(parent: self)
//            try? coordinator.start()
//        case let ShapesAction.featuredShape(route):
//            switch route {
//            case let shapeRoute as SimpleShapesRoute where shapeRoute != .simpleShapes:
//                let coordinator = factory.makeSimpleShapesCoordinator(parent: self)
//                coordinator.append(routes: [.simpleShapes, shapeRoute])
//            case let shapeRoute as CustomShapesRoute where shapeRoute != .customShapes:
//                let coordinator = factory.makeCustomShapesCoordinator(parent: self)
//                coordinator.append(routes: [.customShapes, shapeRoute])
//            default:
//                return
//            }
//        case Action.done(_):
//            popToRoot()
//            childCoordinators.removeAll()
//        default:
//            parent?.handle(action)
//        }
//    }
//    
//    func handle(_ deepLink: DeepLink, with params: [String: String]) {
//        switch deepLink.route {
//        case ShapesRoute.customShapes:
//            let coordinator = factory.makeCustomShapesCoordinator(parent: self)
//            try? coordinator.start()
//        default:
//            break
//        }
//    }
//}
//
//// MARK: - RouterViewFactory
//
//extension MenuPrincipalCoordinator: RouterViewFactory
//{    
//    @ViewBuilder
//    public func view(for route: MenuPrincipalRoute) -> some View {
//        switch route {
//        case .shapes:
//            ShapeListView<ShapesCoordinator>()
//        case .simpleShapes:
//            /// We are returning an empty view for the route presenting a child coordinator.
//            EmptyView()
//        case .customShapes:
//            CustomShapesView<CustomShapesCoordinator>()
//        case .featuredShape:
//            /// We are returning an empty view for the route presenting a child coordinator.
//            EmptyView()
//        }
//    }
//}
