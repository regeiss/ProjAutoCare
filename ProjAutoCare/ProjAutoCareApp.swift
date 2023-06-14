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
    var body: some Scene
    {
        WindowGroup
        {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
