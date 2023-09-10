//
//  MarcaModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 07/09/23.
//

import Foundation

struct MarcaDTO: Codable
{
    let collection: Collection
    let data: [Datum]
}

typealias Marcas = MarcaDTO

// MARK: - Collection
struct Collection: Codable {
    let url: String
    let count, pages, total: Int
    let next, prev, first, last: String
}

// MARK: - Datum
struct Datum: Codable {
    let id: Int
    let name: String
}
