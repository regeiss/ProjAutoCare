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

struct CarAPI: Decodable
{
    private enum RootCodingKeys: String, CodingKey {
        case collection, data
    }
    
    private enum FeatureCodingKeys: String, CodingKey {
        case id, name
    }
    
    private(set) var marcaPropertiesList = [MarcaProperties]()
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
        var featuresContainer = try rootContainer.nestedUnkeyedContainer(forKey: .data)
        
        while !featuresContainer.isAtEnd {
            let propertiesContainer = try featuresContainer.nestedContainer(keyedBy: FeatureCodingKeys.self)
            
            // Decodes a single quake from the data, and appends it to the array, ignoring invalid data.
            if let properties = try? propertiesContainer.decode(MarcaProperties.self, forKey: .id) {
                marcaPropertiesList.append(properties)
            }
        }
    }
}

struct MarcaProperties: Decodable
{
    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
        
    let id: Int
    let name: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let rawId = try? values.decode(Int.self, forKey: .id)
        let rawName = try? values.decode(String.self, forKey: .name)
       
        
        // Ignore earthquakes with missing da0ta.
//        guard let id = rawId,
//              let place = rawName
//        else {
//            let values = "code = \(rawCode?.description ?? "nil"), "
//            + "mag = \(rawMagnitude?.description ?? "nil"), "
//            + "place = \(rawPlace?.description ?? "nil"), "
//            + "time = \(rawTime?.description ?? "nil")"
//
//            let logger = Logger(subsystem: "com.example.apple-samplecode.Earthquakes", category: "parsing")
//            logger.debug("Ignored: \(values)")
//
//            throw ValidationError.missingData
//        }
        
        self.id = rawId ?? 0
        self.name = rawName ?? ""
    }
    
    var dictionaryValue: [String: Any] {
           [
               "id": id,
               "name": name
           ]
       }
}


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
}

