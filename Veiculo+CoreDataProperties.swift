//
//  Veiculo+CoreDataProperties.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 13/07/23.
//
//

import Foundation
import CoreData


extension Veiculo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Veiculo> {
        return NSFetchRequest<Veiculo>(entityName: "Veiculo")
    }

    @NSManaged public var ano: Int16
    @NSManaged public var ativo: Bool
    @NSManaged public var chassis: String?
    @NSManaged public var id: UUID?
    @NSManaged public var marca: String?
    @NSManaged public var modelo: String?
    @NSManaged public var nome: String?
    @NSManaged public var padrao: Bool
    @NSManaged public var placa: String?
    @NSManaged public var doAbastecimento: NSSet?
    @NSManaged public var doPerfil: Perfil?
    @NSManaged public var doItemServico: NSSet?

}

// MARK: Generated accessors for doAbastecimento
extension Veiculo {

    @objc(addDoAbastecimentoObject:)
    @NSManaged public func addToDoAbastecimento(_ value: Abastecimento)

    @objc(removeDoAbastecimentoObject:)
    @NSManaged public func removeFromDoAbastecimento(_ value: Abastecimento)

    @objc(addDoAbastecimento:)
    @NSManaged public func addToDoAbastecimento(_ values: NSSet)

    @objc(removeDoAbastecimento:)
    @NSManaged public func removeFromDoAbastecimento(_ values: NSSet)

}

// MARK: Generated accessors for doItemServico
extension Veiculo {

    @objc(addDoItemServicoObject:)
    @NSManaged public func addToDoItemServico(_ value: ItemServico)

    @objc(removeDoItemServicoObject:)
    @NSManaged public func removeFromDoItemServico(_ value: ItemServico)

    @objc(addDoItemServico:)
    @NSManaged public func addToDoItemServico(_ values: NSSet)

    @objc(removeDoItemServico:)
    @NSManaged public func removeFromDoItemServico(_ values: NSSet)

}

extension Veiculo : Identifiable {

}
