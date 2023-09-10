//
//  CarEndPoint.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 06/09/23.
//

import Foundation

enum CarEndpoint
{
    case make
    case lista
    case continente
    case artigos
    case serieHistorica
}

extension CarEndpoint: Endpoint
{
    var host: String
    {
        switch self
        {
        case .make, .lista, .continente, .serieHistorica:
            return "carapi.app/api"
        case .artigos:
            return "newsapi.org"
        }
    }
    
    var path: String
    {
        switch self
        {
        case .make:
            return "/makes"
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
