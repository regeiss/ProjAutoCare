//
//  File.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 18/09/23.
//

import Foundation
import OSLog
/// A struct for decoding JSON with the following structure:
///
/// {
///    "features": [
///          {
///       "properties": {
///         "mag":1.9,
///         "place":"21km ENE of Honaunau-Napoopoo, Hawaii",
///         "time":1539187727610,"updated":1539187924350,
///         "code":"70643082"
///       }
///     }
///   ]
/// }
///
struct GeoJSON: Decodable {
    
    private enum RootCodingKeys: String, CodingKey {
        case features
    }
    
    private enum FeatureCodingKeys: String, CodingKey {
        case properties
    }
    
    private(set) var quakePropertiesList = [QuakeProperties]()

    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
        var featuresContainer = try rootContainer.nestedUnkeyedContainer(forKey: .features)
        
        while !featuresContainer.isAtEnd {
            let propertiesContainer = try featuresContainer.nestedContainer(keyedBy: FeatureCodingKeys.self)
            
            // Decodes a single quake from the data, and appends it to the array, ignoring invalid data.
            if let properties = try? propertiesContainer.decode(QuakeProperties.self, forKey: .properties) {
                quakePropertiesList.append(properties)
            }
        }
    }
}

struct QuakeProperties: Decodable {

    // MARK: Codable
    
    private enum CodingKeys: String, CodingKey {
        case magnitude = "mag"
        case place
        case time
        case code
    }
    
    let magnitude: Float   // 1.9
    let place: String      // "21km ENE of Honaunau-Napoopoo, Hawaii"
    let time: Double       // 1539187727610
    let code: String       // "70643082"
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let rawMagnitude = try? values.decode(Float.self, forKey: .magnitude)
        let rawPlace = try? values.decode(String.self, forKey: .place)
        let rawTime = try? values.decode(Double.self, forKey: .time)
        let rawCode = try? values.decode(String.self, forKey: .code)
        
        // Ignore earthquakes with missing data.
        guard let magntiude = rawMagnitude,
              let place = rawPlace,
              let time = rawTime,
              let code = rawCode
        else {
            let values = "code = \(rawCode?.description ?? "nil"), "
            + "mag = \(rawMagnitude?.description ?? "nil"), "
            + "place = \(rawPlace?.description ?? "nil"), "
            + "time = \(rawTime?.description ?? "nil")"

            let logger = Logger(subsystem: "com.example.apple-samplecode.Earthquakes", category: "parsing")
            logger.debug("Ignored: \(values)")

            throw ValidationError.missingData
        }
        
        self.magnitude = magntiude
        self.place = place
        self.time = time
        self.code = code
    }
    
    // The keys must have the same name as the attributes of the Quake entity.
    var dictionaryValue: [String: Any] {
        [
            "magnitude": magnitude,
            "place": place,
            "time": Date(timeIntervalSince1970: TimeInterval(time) / 1000),
            "code": code
        ]
    }
}
