//
//  Perfil+CoreDataProperties.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 02/07/23.
//
//

import Foundation
import CoreData

extension Perfil {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Perfil> {
        return NSFetchRequest<Perfil>(entityName: "Perfil")
    }

    @NSManaged public var nome: String?
    @NSManaged public var id: UUID?
    @NSManaged public var email: String?
    @NSManaged public var ativo: Bool
    @NSManaged public var padrao: Bool

}

extension Perfil: Identifiable {

}
