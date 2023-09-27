//
//  MarcaModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 07/09/23.
//

import Foundation
import OSLog

typealias Marcas = MarcaDTO

struct MarcaDTO: Codable
{
    let collection: Collection
    let data: [DataMarca]
}

// MARK: - Collection
struct Collection: Codable 
{
    let url: String
    let count, pages, total: Int
    let next, prev, first, last: String
}

// MARK: - Datum
struct DataMarca: Codable 
{
    let id: Int
    let name: String
}
