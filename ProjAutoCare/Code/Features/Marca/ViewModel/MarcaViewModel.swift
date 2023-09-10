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

@MainActor
final class MarcaViewModelImpl: MarcaViewModel
{
    enum State
    {
        case na
        case loading
        case success(data: Marcas)
        case failed(error: Error)
    }

    @Published private(set) var state: State = .na
    @Published var hasError: Bool = false
    @Published var carregando: Bool = false
    
    private let service: NetworkService

    init(service: NetworkService)
    {
        self.service = service
    }
    
    func getAllMarcas() async
    {
        self.state = .loading
        self.hasError = false
        self.carregando = true
        
        let logger = Logger.init(subsystem: Bundle.main.bundleIdentifier!, category: "main")
        logger.trace("Iniciando fetch")
        
        let result = await service.getAllMarcas()
        switch result
        {
        case .success(let data):
            self.state = .success(data: data)
            self.carregando = false
        case .failure(let error):
            self.state = .failed(error: error)
            self.hasError = true
            self.carregando = false
            print(String(describing: error))
            logger.error("\(error.localizedDescription, privacy: .public)")
        }
        logger.trace("Finalizando fetch")
    }
    
    // TODO: Arrumar
    private func newBatchInsertRequest(with marcas: [Marcas]) -> NSBatchInsertRequest
    {
      // 1
      var index = 0
      let total = marcas.count

      // 2
      let batchInsert = NSBatchInsertRequest(
        entity: Marca.entity()) { (managedObject: NSManagedObject) -> Bool in
        // 3
        guard index < total else { return true }

        if let marca = managedObject as? Marca {
          // 4
          let data = marcas[index]
            marca.id = Int16(index)
          marca.nome = ""
        }

        // 5
        index += 1
        return false
      }
      return batchInsert
    }
}
