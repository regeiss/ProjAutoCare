//
//  EndPoint.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 06/09/23.
//

import Foundation

enum HostEndpoint
{
    case estatisticas
    case artigos
}

protocol Endpoint
{
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
}

extension Endpoint
{
    var scheme: String
    {
        return "https"
    }
}
