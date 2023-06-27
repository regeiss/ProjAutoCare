//
//  Posto+CoreDataProperties.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 26/06/23.
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

}

extension Posto : Identifiable {

}
