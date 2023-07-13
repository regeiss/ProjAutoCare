//
//  ItemServico+CoreDataProperties.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 13/07/23.
//
//

import Foundation
import CoreData


extension ItemServico {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemServico> {
        return NSFetchRequest<ItemServico>(entityName: "ItemServico")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var quilometragem: Int32
    @NSManaged public var data: Date?
    @NSManaged public var nome: String?
    @NSManaged public var custo: Double
    @NSManaged public var observacoes: String?
    @NSManaged public var doServico: Servico?
    @NSManaged public var doVeiculo: Veiculo?

}

extension ItemServico : Identifiable {

}
