//
//  AppCoordinator.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 25/10/23.
//

import Foundation
import SwiftUICoordinator

final class AppCoordinator: RootCoordinator {
    
    func start(with coordinator: any Routing) {
        self.add(child: coordinator)
        try? coordinator.start()
    }
    
    override func handle(_ action: CoordinatorAction) {
        fatalError("Unhadled coordinator action.")
    }
}
