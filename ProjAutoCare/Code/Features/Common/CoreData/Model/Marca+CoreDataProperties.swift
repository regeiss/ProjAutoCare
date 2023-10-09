//
//  Marca+CoreDataProperties.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 08/10/23.
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
    @NSManaged public var fabrica: NSSet?

}

// MARK: Generated accessors for fabrica
extension Marca {

    @objc(addFabricaObject:)
    @NSManaged public func addToFabrica(_ value: Modelo)

    @objc(removeFabricaObject:)
    @NSManaged public func removeFromFabrica(_ value: Modelo)

    @objc(addFabrica:)
    @NSManaged public func addToFabrica(_ values: NSSet)

    @objc(removeFabrica:)
    @NSManaged public func removeFromFabrica(_ values: NSSet)

}

extension Marca : Identifiable {

}
