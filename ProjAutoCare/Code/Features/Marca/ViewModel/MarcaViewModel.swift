//
//  MarcaViewModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 07/09/23.
//

import Foundation
import OSLog
import CoreData

protocol MarcaViewModel: ObservableObject
{
    func getAllMarcas() async 
}

final class MarcaViewModelImpl: MarcaViewModel
{
    
    enum State
    {
        case na
        case success(data: Marcas)
        case failed(error: Error)
    }
    
    @Published var hasError: Bool = false
    @Published var carregando: Bool = false
    @Published var state: State = .na
    
    private let service: NetworkService
    
    init(service: NetworkService)
    {
        self.service = service
    }
    
    func getAllMarcas() async
    {
        self.hasError = false
        
        let logger = Logger.init(subsystem: Bundle.main.bundleIdentifier!, category: "main")
        logger.trace("Iniciando fetch")
        
        let result = await service.getAllMarcas()
        switch result
        {
        
        case .success(let data):
            self.state = .success(data: data)
           
        case .failure(let error):
            self.state = .failed(error: error)
            self.hasError = true
            print(String(describing: error))
            logger.error("\(error.localizedDescription, privacy: .public)")
        }
        logger.trace("Finalizando fetch")
    }
}
