//
//  ItemServicoModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 13/07/23.
//

import Foundation

struct ServicoEfetuadoDTO: Identifiable
{
    let id: UUID
    let quilometragem: Int32
    let data: Date
    let nome: String
    let custo: Double
    let observacoes: String
    let doServico: Servico
    let doVeiculo: Veiculo
}
