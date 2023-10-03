//
//  Categoria+CoreDataProperties.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 13/07/23.
//
//

import Foundation
import CoreData


extension Categoria {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Categoria> {
        return NSFetchRequest<Categoria>(entityName: "Categoria")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var nome: String?
    @NSManaged public var temServicos: NSSet?

}

// MARK: Generated accessors for temServicos
extension Categoria {

    @objc(addTemServicosObject:)
    @NSManaged public func addToTemServicos(_ value: Servico)

    @objc(removeTemServicosObject:)
    @NSManaged public func removeFromTemServicos(_ value: Servico)

    @objc(addTemServicos:)
    @NSManaged public func addToTemServicos(_ values: NSSet)

    @objc(removeTemServicos:)
    @NSManaged public func removeFromTemServicos(_ values: NSSet)

}

extension Categoria: Identifiable {

}
