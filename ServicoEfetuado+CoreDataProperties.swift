//
//  ServicoEfetuado+CoreDataProperties.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 13/07/23.
//
//

import Foundation
import CoreData


extension ServicoEfetuado {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ServicoEfetuado> {
        return NSFetchRequest<ServicoEfetuado>(entityName: "ServicoEfetuado")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var nome: String?
    @NSManaged public var quilometragem: Int32
    @NSManaged public var observacoes: String?
    @NSManaged public var data: Date?
    @NSManaged public var custo: Double
    @NSManaged public var doVeiculo: Veiculo?
    @NSManaged public var doServico: Servico?

}

extension ServicoEfetuado : Identifiable {

}
