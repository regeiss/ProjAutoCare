//
//  MarcaModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 07/09/23.
//

import Foundation
import OSLog

// {
//  "collection": {
//    "url": "/collection",
//    "count": 50,
//    "pages": 20,
//    "total": 200,
//    "next": "/collection?page=:number",
//    "prev": "/collection?page=:number",
//    "first": "/collection?page=:number",
//    "last": "/collection?page=:number"
//  },
//  "data": [
//    {
//      "id": 0,
//      "name": "string"
//    }
//  ]
// }
typealias Marcas = MarcaDTO

struct MarcaDTO: Codable
{
    let collection: Collection
    let data: [Datum]
}

// MARK: - Collection
struct Collection: Codable 
{
    let url: String
    let count, pages, total: Int
    let next, prev, first, last: String
}

// MARK: - Datum
struct Datum: Codable 
{
    let id: Int
    let name: String
}
