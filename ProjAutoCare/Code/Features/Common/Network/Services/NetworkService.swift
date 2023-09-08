//
//  NetworkService.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 06/09/23.
//

import Foundation

protocol NetworkServiceable
{
//    func getEstatisticas() async -> Result<EstatisticasMundialModel, RequestError>
//    func getListaPaises() async -> Result<PaisModel, RequestError>
//    func getInfoContinentes() async -> Result<ContinenteModel, RequestError>
//    func getAllArtigos() async -> Result<ArtigoModel, RequestError>
//    func getSerieHistorica() async -> Result<MundialSeriesModel, RequestError>
}

class NetworkService: HTTPClient, NetworkServiceable
{
    func getAllMarcas() async -> Result<MarcaDTO, RequestError>
    {
        return await sendRequest(endpoint: CarEndpoint.make, responseModel: MarcaDTO.self)
    }
    
//    func getListaPaises() async -> Result<PaisModel, RequestError>
//    {
//        return await sendRequest(endpoint: COVIDEndpoint.lista, responseModel: PaisModel.self)
//    }
//
//    func getInfoContinentes() async -> Result<ContinenteModel, RequestError>
//    {
//        return await sendRequest(endpoint: COVIDEndpoint.continente, responseModel: ContinenteModel.self)
//    }
//    
//    func getAllArtigos() async -> Result<ArtigoModel, RequestError>
//    {
//        return await sendRequest(endpoint: COVIDEndpoint.artigos, responseModel: ArtigoModel.self)
//    }
//
//    func getSerieHistorica() async -> Result<MundialSeriesModel, RequestError>
//    {
//        return await sendRequest(endpoint: COVIDEndpoint.serieHistorica, responseModel: MundialSeriesModel.self)
//    }
}
