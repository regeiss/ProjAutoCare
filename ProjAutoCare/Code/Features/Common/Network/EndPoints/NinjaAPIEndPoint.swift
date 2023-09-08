//
//  NinjaAPIEndPoint.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 07/09/23.
//

import Foundation

enum NinjaAPIEndpoint
{
    case make
    case lista
    case continente
    case artigos
    case serieHistorica
}

extension NinjaAPIEndpoint: Endpoint
{
    var host: String
    {
        switch self
        {
        case .make, .lista, .continente, .serieHistorica:
            return "disease.sh"
        case .artigos:
            return "newsapi.org"
        }
    }
    
    var path: String
    {
        switch self
        {
        case .make:
            return "/v3/covid-19/all"
        case .lista:
            return "/v3/covid-19/countries"
        case .continente:
            return "/v3/covid-19/continents"
        case .artigos:
            return "/v2/everything"
        case .serieHistorica:
            return "/v3/covid-19/historical/all"
        }
    }
    
    var method: RequestMethod
    {
        switch self
        {
        case .make, .lista, .continente, .artigos, .serieHistorica:
            return .get
        }
    }
    
    var header: [String: String]?
    {
        return nil
    }
    
    var body: [String: String]?
    {
        return nil
    }
}
