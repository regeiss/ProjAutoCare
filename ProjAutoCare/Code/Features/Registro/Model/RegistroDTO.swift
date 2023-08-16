//
//  RegistroDTO.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 15/08/23.
//

import Foundation

struct RegistroDTO: Identifiable, Hashable
{
    var id: UUID
    var data: Date
    var tipo: String
    var idTipo: UUID
}
