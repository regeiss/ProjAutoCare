//
//  Perfil+CoreDataProperties.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 13/07/23.
//
//

import Foundation
import CoreData


extension Perfil {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Perfil> {
        return NSFetchRequest<Perfil>(entityName: "Perfil")
    }

    @NSManaged public var ativo: Bool
    @NSManaged public var email: String?
    @NSManaged public var id: UUID?
    @NSManaged public var nome: String?
    @NSManaged public var padrao: Bool
    @NSManaged public var eProprietario: NSSet?

}

// MARK: Generated accessors for eProprietario
extension Perfil {

    @objc(addEProprietarioObject:)
    @NSManaged public func addToEProprietario(_ value: Veiculo)

    @objc(removeEProprietarioObject:)
    @NSManaged public func removeFromEProprietario(_ value: Veiculo)

    @objc(addEProprietario:)
    @NSManaged public func addToEProprietario(_ values: NSSet)

    @objc(removeEProprietario:)
    @NSManaged public func removeFromEProprietario(_ values: NSSet)

}

extension Perfil : Identifiable {

}
