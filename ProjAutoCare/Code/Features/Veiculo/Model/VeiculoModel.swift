//
//  VeiculoModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 01/07/23.
//

import Foundation

struct VeiculoDTO: Identifiable
{
    let id: UUID
    let nome: String
    let marca: String
    let modelo: String
    let placa: String
    let chassis: String
    let ativo: Bool
    let padrao: Bool
    let ano: Int16
}
