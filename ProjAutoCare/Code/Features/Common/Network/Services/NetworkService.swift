//
//  NetworkService.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 06/09/23.
//

import Foundation

protocol NetworkServiceable
{
    func getAllMarcas() async -> Result<Marcas, RequestError>
}

class NetworkService: HTTPClient, NetworkServiceable
{
    func getAllMarcas() async -> Result<Marcas, RequestError>
    {
        return await sendRequest(endpoint: CarEndpoint.make, responseModel: Marcas.self)
    }
}
