//
//  Servico+CoreDataProperties.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 13/07/23.
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
    @NSManaged public var daCategoria: Categoria?
    @NSManaged public var daManutencao: NSSet?

}

// MARK: Generated accessors for daManutencao
extension Servico {

    @objc(addDaManutencaoObject:)
    @NSManaged public func addToDaManutencao(_ value: ServicoEfetuado)

    @objc(removeDaManutencaoObject:)
    @NSManaged public func removeFromDaManutencao(_ value: ServicoEfetuado)

    @objc(addDaManutencao:)
    @NSManaged public func addToDaManutencao(_ values: NSSet)

    @objc(removeDaManutencao:)
    @NSManaged public func removeFromDaManutencao(_ values: NSSet)

}

extension Servico: Identifiable {

}
