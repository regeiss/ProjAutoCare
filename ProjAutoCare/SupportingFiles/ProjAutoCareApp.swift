//
//  ProjAutoCareApp.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 12/06/23.
//

import SwiftUI
import CoreData

@main
struct ProjAutoCareApp: App
{
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.managedObjectContext) private var moc: NSManagedObjectContext
    static let persistenceController = PersistenceController.shared
    
    var body: some Scene
    {
        WindowGroup
        {
            ContentView()
                .environment(\.managedObjectContext, ProjAutoCareApp.persistenceController.container.viewContext)
                .modifier(DarkModeViewModifier())
        }
        .onChange(of: scenePhase)
        {
            switch scenePhase
            {
            case .active:
                print("active")
                getCoreDataDBPath()
            case .inactive:
                print("inactive")
            case .background:
                print("background")
                saveContext()
            @unknown default:
                fatalError()
            }
        }
    }
    
    func saveContext()
    {
        let context = moc
        if context.hasChanges
        {
            do
            {
                try context.save()
            }
            catch
            {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getCoreDataDBPath()
    {
        let path = FileManager
            .default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .last?
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding
        
        print("Core Data DB Path :: \(path ?? "Not found")")
    }
}
