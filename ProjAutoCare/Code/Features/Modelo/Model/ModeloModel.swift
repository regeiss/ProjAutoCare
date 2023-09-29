//
//  ModeloModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 26/09/23.
//

import Foundation
import OSLog

typealias Modelos = ModeloDTO

struct ModeloDTO: Codable
{
    let collection: CollectionModelo
    let data: [DataModelo]
}

// MARK: - Collection
struct CollectionModelo: Codable
{
    let url: String
    let count, pages, total: Int
    let next, prev, first, last: String
}

// MARK: - Datum
struct DataModelo: Codable
{
    let id: Int
    let makeid: Int
    let name: String
}
