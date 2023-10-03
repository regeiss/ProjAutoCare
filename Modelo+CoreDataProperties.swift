//
//  Modelo+CoreDataProperties.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 01/10/23.
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
    @NSManaged public var efabricado: Marca?
    @NSManaged public var modeloveiculo: NSSet?

}

// MARK: Generated accessors for modeloveiculo
extension Modelo {

    @objc(addModeloveiculoObject:)
    @NSManaged public func addToModeloveiculo(_ value: Veiculo)

    @objc(removeModeloveiculoObject:)
    @NSManaged public func removeFromModeloveiculo(_ value: Veiculo)

    @objc(addModeloveiculo:)
    @NSManaged public func addToModeloveiculo(_ values: NSSet)

    @objc(removeModeloveiculo:)
    @NSManaged public func removeFromModeloveiculo(_ values: NSSet)

}

extension Modelo: Identifiable {

}
