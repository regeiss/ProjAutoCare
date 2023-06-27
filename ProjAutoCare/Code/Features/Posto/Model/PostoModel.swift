//
//  PostoModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 26/06/23.
//

import Foundation

struct PostoDTO: Identifiable
{
    let id: UUID
    let nome: String
    let bandeira: String
    let padrao: Bool
}
