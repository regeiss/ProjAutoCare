//
//  AbastecimentoModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/06/23.
//

import Foundation

class AbastecimentoDTO: Identifiable
{
    var id: UUID
    var km: Int32
    var data: Date
    var litros: Double
    var valorLitro: Double
    var valorTotal: Decimal
    var completo: Bool
    var media: Double
    
    init(id: UUID, km: Int32, data: Date, litros: Double, valorLitro: Double, valorTotal: Decimal, completo: Bool, media: Double)
    {
        self.id = id
        self.km = km
        self.data = data
        self.litros = litros
        self.valorLitro = valorLitro
        self.valorTotal = valorTotal
        self.completo = completo
        self.media = media
    }
}
