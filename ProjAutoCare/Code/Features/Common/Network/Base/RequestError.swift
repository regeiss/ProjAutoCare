//
//  RequestError.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 06/09/23.
//

import Foundation

enum RequestError: Error
{
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
    
    var customMessage: String
    {
        switch self
        {
        case .decode:
            return "Decode error"
        case .invalidURL:
            return "URL inválida"
        case .unauthorized:
            return "Session expired"
        default:
            return "Unknown error"
        }
    }
}
