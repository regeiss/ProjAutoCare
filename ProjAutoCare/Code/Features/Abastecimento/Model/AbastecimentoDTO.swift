//
//  AbastecimentoModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/06/23.
//

import Foundation

struct AbastecimentoDTO: Identifiable
{
    let id: UUID
    let quilometragem: Int32
    let data: Date
    let litros: Double
    let valorLitro: Double
    let valorTotal: Double
    let completo: Bool
    let media: Double
    let noPosto: Posto
    let doVeiculo: Veiculo
}
