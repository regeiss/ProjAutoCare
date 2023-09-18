//
//  File.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 18/09/23.
//

import Foundation
import OSLog

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
