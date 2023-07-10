//
//  Servico+CoreDataProperties.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 09/07/23.
//
//

import Foundation
import CoreData


extension Servico {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Servico> {
        return NSFetchRequest<Servico>(entityName: "Servico")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var nome: String?

}

extension Servico : Identifiable {

}
