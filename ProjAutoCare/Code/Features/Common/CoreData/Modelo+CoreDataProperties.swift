//
//  Modelo+CoreDataProperties.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 25/09/23.
//
//

import Foundation
import CoreData

extension Modelo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Modelo> {
        return NSFetchRequest<Modelo>(entityName: "Modelo")
    }

    @NSManaged public var id: Int16
    @NSManaged public var idmarca: Int16
    @NSManaged public var nome: String?

}

extension Modelo: Identifiable {

}
