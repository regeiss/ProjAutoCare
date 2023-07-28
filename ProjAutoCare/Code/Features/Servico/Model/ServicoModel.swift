//
//  ServicoModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 09/07/23.
//

import Foundation

struct ServicoDTO: Identifiable
{
    let id: UUID
    let nome: String
    let daCategoria: Categoria
}
