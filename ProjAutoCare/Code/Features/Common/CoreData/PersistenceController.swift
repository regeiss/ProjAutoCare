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
        init(inMemory: Bool = false) {
            container = NSPersistentContainer(name: "projetoCoreData")
            if inMemory
            {
                container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
            }
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError?
                {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            container.viewContext.automaticallyMergesChangesFromParent = true
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
}
