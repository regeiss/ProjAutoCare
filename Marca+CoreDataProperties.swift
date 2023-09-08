//
//  Marca+CoreDataProperties.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 07/09/23.
//
//

import Foundation
import CoreData


extension Marca {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Marca> {
        return NSFetchRequest<Marca>(entityName: "Marca")
    }

    @NSManaged public var id: Int16
    @NSManaged public var nome: String?

}

extension Marca : Identifiable {

}
