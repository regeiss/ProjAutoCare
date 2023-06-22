//
//  AbastecimentoModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/06/23.
//

import Foundation
import SwiftData

@Model

class AbastecimentoModel
{
    @Attribute(.unique) var id: UUID
    var kms: Int32
    var data: Date
    var litros: Double
    var valorLitro: Double
    var valorTotal: Double
    var completo: Bool
    var media: Double
    
    init(id: UUID, kms: Int32, data: Date, litros: Double, valorLitro: Double, valorTotal: Double, completo: Bool, media: Double)
    {
        self.id = id
        self.kms = kms
        self.data = data
        self.litros = litros
        self.valorLitro = valorLitro
        self.valorTotal = valorTotal
        self.completo = completo
        self.media = media
    }
}
