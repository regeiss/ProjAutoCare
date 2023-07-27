//
//  VeiculoAction.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 01/07/23.
//

import CoreData
import Combine
import OSLog

class VeiculoPublisher: NSObject, ObservableObject
{
    static let shared = VeiculoPublisher()
    var appState = AppState.shared
    
    var veiculoCVS = CurrentValueSubject<[Veiculo], Never>([])
    private let veiculoFetchController: NSFetchedResultsController<Veiculo>
    
    var logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Publisher")

    var publisherContext: NSManagedObjectContext = {
         let context = PersistenceController.shared.container.viewContext
             context.mergePolicy = NSMergePolicy( merge: .mergeByPropertyObjectTrumpMergePolicyType)
             context.automaticallyMergesChangesFromParent = true
         return context
         }()

    private override init()
    {
        let fetchRequest: NSFetchRequest<Veiculo> = Veiculo.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: false)

        fetchRequest.sortDescriptors = [sortDescriptor]

        veiculoFetchController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: publisherContext,
            sectionNameKeyPath: nil, cacheName: nil
        )

        super.init()

        veiculoFetchController.delegate = self

        do
        {
            try veiculoFetchController.performFetch()
            veiculoCVS.value = veiculoFetchController.fetchedObjects ?? []
        }
        catch
        {
            NSLog("Erro: could not fetch objects")
        }
    }

    func add(veiculo: VeiculoDTO)
    {
        let newVeiculo = Veiculo(context: publisherContext)
        newVeiculo.id = veiculo.id
        newVeiculo.nome = veiculo.nome
        newVeiculo.marca = veiculo.marca
        newVeiculo.modelo = veiculo.modelo
        newVeiculo.placa = veiculo.placa
        newVeiculo.chassis = veiculo.chassis
        newVeiculo.ano = veiculo.ano

        publisherContext.performAndWait
        {
            do
            {
                try self.publisherContext.save()
            }
            catch
            {
                fatalError("Erro moc \(error.localizedDescription)")
            }
        }
    }

    func update(veiculo: Veiculo)
    {
        publisherContext.performAndWait
        {
            do
            {
                try self.publisherContext.save()
            }
            catch
            {
                fatalError("Erro moc \(error.localizedDescription)")
            }
        }
    }

    func delete(veiculo: Veiculo)
    {
        publisherContext.performAndWait
        {
            publisherContext.delete(veiculo)
            do
            {
                try self.publisherContext.save()
            }
            catch
            {
                fatalError("Erro moc \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: Veiculo padrão
    func inserePadrao()
    {
        let newVeiculo = Veiculo(context: publisherContext)
            newVeiculo.id = UUID()
            newVeiculo.nome = "padrão"
            newVeiculo.marca = "padrão"
            newVeiculo.modelo = "padrão"
            newVeiculo.placa = "padrão"
            newVeiculo.chassis = "padrão"
            newVeiculo.ano = Int16(0)
            newVeiculo.ativo = true
        
        publisherContext.performAndWait
        {
            do
            {
                try self.publisherContext.save()
            }
            catch
            {
                fatalError("Erro moc \(error.localizedDescription)")
            }
        }

        appState.veiculoAtivo = newVeiculo
    }

    func selecionarVeiculoAtivo()
    {
        let fetchRequest: NSFetchRequest<Veiculo> = Veiculo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(ativo == 1)")
        fetchRequest.fetchLimit = 1

        do
        {
            logger.log("Context has changed, buscando veiculo atual")
            guard let veiculoAtual = try publisherContext.fetch(fetchRequest).first
            else { return }
            appState.veiculoAtivo = veiculoAtual
        }
        catch
        {
            fatalError("Erro moc \(error.localizedDescription)")
        }
    }

    func marcarVeiculoAtivo(ativoID: NSManagedObjectID)
    {
        // Desmarcar o ativo
        logger.log("Context has changed, marcando veiculo atual")

        let entityDescription = NSEntityDescription.entity(forEntityName: "Veiculo", in: publisherContext)
        let batchUpdateRequest = NSBatchUpdateRequest(entity: entityDescription!)
        
        batchUpdateRequest.resultType = .updatedObjectIDsResultType
        batchUpdateRequest.propertiesToUpdate = ["ativo": NSNumber(value: false)]
        
        do
        {
            let batchUpdateResult = try publisherContext.execute(batchUpdateRequest) as! NSBatchUpdateResult
            
            let objectIDs = batchUpdateResult.result as! [NSManagedObjectID]
            
            for objectID in objectIDs
            {
                // Turn Managed Objects into Faults
                let managedObject = publisherContext.object(with: objectID)
                publisherContext.refresh(managedObject, mergeChanges: false)
            }

            try self.veiculoFetchController.performFetch()
            
        }
        catch
        {
            let updateError = error as NSError
            print("\(updateError), \(updateError.userInfo)")
        }
        //
        do
        {
            let object = try publisherContext.existingObject(with: ativoID)
            logger.log("Context has changed, buscando veiculo atual")
            object.setValue(true, forKey: "ativo")
            update(veiculo: object as! Veiculo)

            appState.veiculoAtivo = object as? Veiculo
        }
        catch
        {
            fatalError("Erro moc \(error.localizedDescription)")
        }
    }
}

extension VeiculoPublisher: NSFetchedResultsControllerDelegate
{
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        guard let veiculos = controller.fetchedObjects as? [Veiculo]
        else { return}
        logger.log("Context has changed, reloading veiculos")
        self.veiculoCVS.value = veiculos
    }
}
