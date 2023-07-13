//
//  Posto+CoreDataProperties.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 13/07/23.
//
//

import Foundation
import CoreData


extension Posto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Posto> {
        return NSFetchRequest<Posto>(entityName: "Posto")
    }

    @NSManaged public var bandeira: String?
    @NSManaged public var id: UUID?
    @NSManaged public var nome: String?
    @NSManaged public var padrao: Bool
    @NSManaged public var doAbastecimento: NSSet?

}

// MARK: Generated accessors for doAbastecimento
extension Posto {

    @objc(addDoAbastecimentoObject:)
    @NSManaged public func addToDoAbastecimento(_ value: Abastecimento)

    @objc(removeDoAbastecimentoObject:)
    @NSManaged public func removeFromDoAbastecimento(_ value: Abastecimento)

    @objc(addDoAbastecimento:)
    @NSManaged public func addToDoAbastecimento(_ values: NSSet)

    @objc(removeDoAbastecimento:)
    @NSManaged public func removeFromDoAbastecimento(_ values: NSSet)

}

extension Posto : Identifiable {

}
