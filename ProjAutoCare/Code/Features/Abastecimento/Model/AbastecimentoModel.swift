//
//  AbastecimentoModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/06/23.
//

import Foundation
import SwiftData

@Model
final class AbastecimentoModel
{
    @Attribute(.unique) var id: UUID
    var kms: Int32
    var data: Date
    var litros: Double
    var valorLitro: Double
    var valorTotal: Double
    var completo: Bool
    var media: Double
}
