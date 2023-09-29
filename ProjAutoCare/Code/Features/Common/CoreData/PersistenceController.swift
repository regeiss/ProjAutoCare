//
//  PersistenceController.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 21/06/23.
//

import Foundation
import CoreData

struct PersistenceController
{
    static let shared = PersistenceController()
    let container: NSPersistentContainer
        init(inMemory: Bool = false) 
        {
            container = NSPersistentContainer(name: "AutoCare")
            let description = container.persistentStoreDescriptions.first
                    description?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            let remoteChangeKey = "NSPersistentStoreRemoteChangeNotificationOptionKey"
                   description?.setOption(true as NSNumber, forKey: remoteChangeKey)
            
            if inMemory
            {
                container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
            }
            container.loadPersistentStores(completionHandler: { (_, error) in
                if let error = error as NSError?
                {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            container.viewContext.automaticallyMergesChangesFromParent = true
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
}
