//
//  Registro+CoreDataProperties.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 15/08/23.
//
//

import Foundation
import CoreData


extension Registro {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Registro> {
        return NSFetchRequest<Registro>(entityName: "Registro")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var data: Date?
    @NSManaged public var tipo: String?
    @NSManaged public var idTipo: UUID?

}

extension Registro: Identifiable {

}
