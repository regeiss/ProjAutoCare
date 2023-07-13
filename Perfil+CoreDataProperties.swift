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
    @NSManaged public var doVeiculo: NSSet?

}

// MARK: Generated accessors for doVeiculo
extension Perfil {

    @objc(addDoVeiculoObject:)
    @NSManaged public func addToDoVeiculo(_ value: Veiculo)

    @objc(removeDoVeiculoObject:)
    @NSManaged public func removeFromDoVeiculo(_ value: Veiculo)

    @objc(addDoVeiculo:)
    @NSManaged public func addToDoVeiculo(_ values: NSSet)

    @objc(removeDoVeiculo:)
    @NSManaged public func removeFromDoVeiculo(_ values: NSSet)

}

extension Perfil : Identifiable {

}
