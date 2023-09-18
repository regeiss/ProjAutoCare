//
//  MarcaModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 07/09/23.
//

import Foundation
import OSLog

struct MarcaDTO: Codable
{
    let collection: Collection
    let data: [Datum]
    
    private enum RootCodingKeys: String, CodingKey {
            case features
        }
        
        private enum FeatureCodingKeys: String, CodingKey {
            case properties
        }
    private(set) var marcasPropertiesList = [Datum]()
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
    
    var dictionaryValue: [String: Any] {
           [
               "id": id,
               "name": name
           ]
       }
}

typealias Marcas = MarcaDTO


