//
//  ProjAutoCareApp.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 12/06/23.
//

import SwiftUI
import SwiftData

@main
struct ProjAutoCareApp: App
{
    @Environment(\.scenePhase) private var scenePhase
    var body: some Scene
    {
        WindowGroup
        {
            ContentView()
        }
        .modelContainer(for: Item.self)
        .onChange(of: scenePhase)
            {
                switch scenePhase
                {
                case .active:
                    print("active")
                case .inactive:
                    print("inactive")
                case .background:
                    print("background")
                @unknown default:
                    fatalError()
                }
            }
    }
}
