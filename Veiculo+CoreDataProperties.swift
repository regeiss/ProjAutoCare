//
//  Veiculo+CoreDataProperties.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 01/07/23.
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
    @NSManaged public var marca: String?
    @NSManaged public var modelo: String?
    @NSManaged public var placa: String?
    @NSManaged public var chassis: String?
    @NSManaged public var padrao: Bool
    @NSManaged public var ativo: Bool
    @NSManaged public var ano: Int16

}

extension Veiculo : Identifiable {

}
