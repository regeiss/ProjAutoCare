//
//  Veiculo+CoreDataProperties.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 25/06/23.
//
//

import Foundation
import CoreData


extension Veiculo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Veiculo> {
        return NSFetchRequest<Veiculo>(entityName: "Veiculo")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var nome: String?

}

extension Veiculo : Identifiable {

}
