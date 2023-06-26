//
//  Abastecimento+CoreDataProperties.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 25/06/23.
//
//

import Foundation
import CoreData


extension Abastecimento {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Abastecimento> {
        return NSFetchRequest<Abastecimento>(entityName: "Abastecimento")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var data: Date?
    @NSManaged public var litros: Double
    @NSManaged public var km: Int32
    @NSManaged public var media: Double
    @NSManaged public var valorLitro: Double
    @NSManaged public var valorTotal: Double
    @NSManaged public var completo: Bool

}

extension Abastecimento : Identifiable {

}
