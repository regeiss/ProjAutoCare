//
//  PerfilModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 29/06/23.
//

import Foundation

struct PerfilDTO: Identifiable
{
    let id: UUID
    let nome: String
    let email: String
    let ativo: Bool
    let padrao: Bool
}
