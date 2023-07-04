//
//  PerfilAction.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 29/06/23.
//

import CoreData
import Combine
import OSLog
import SwiftUI

class PerfilPublisher: NSObject, ObservableObject
{
    static let shared = PerfilPublisher()
    var appState = AppState.shared
    
    var perfilCVS = CurrentValueSubject<[Perfil], Never>([])
    private let perfilFetchController: NSFetchedResultsController<Perfil>
    
    var logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Publisher")
    
    var publisherContext: NSManagedObjectContext = {
        let context = PersistenceController.shared.container.viewContext
        context.mergePolicy = NSMergePolicy( merge: .mergeByPropertyObjectTrumpMergePolicyType)
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    private override init()
    {
        let fetchRequest: NSFetchRequest<Perfil> = Perfil.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.returnsDistinctResults = true
        
        perfilFetchController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: publisherContext,
            sectionNameKeyPath: nil, cacheName: nil
        )
        
        super.init()
        
        perfilFetchController.delegate = self
        
        do
        {
            try perfilFetchController.performFetch()
            perfilCVS.value = perfilFetchController.fetchedObjects ?? []
        }
        catch
        {
            NSLog("Erro: could not fetch objects")
        }
    }
    
    func add(perfil: PerfilDTO)
    {
        let newPerfil = Perfil(context: publisherContext)
        newPerfil.id = perfil.id
        newPerfil.nome = perfil.nome
        newPerfil.email = perfil.email
        
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
    
    func update(perfil: Perfil)
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
    
    func delete(perfil: Perfil)
    {
        publisherContext.performAndWait
        {
            publisherContext.delete(perfil)
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
    
    // MARK: Perfil padrão
    func inserePadrao()
    {
        let newPerfil = Perfil(context: publisherContext)
        newPerfil.id = UUID()
        newPerfil.nome = "Padrão"
        newPerfil.email = "padrão@com.br"
        newPerfil.ativo = true
        
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
        
        appState.perfilAtivo = newPerfil
    }
    
    func selecionarPerfilAtivo()
    {
        let fetchRequest: NSFetchRequest<Perfil> = Perfil.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(ativo == true)")
        fetchRequest.fetchLimit = 1

        do
        {
            guard let perfilAtivo = try publisherContext.fetch(fetchRequest).first
            else { return }
            
            appState.perfilAtivo = perfilAtivo
            logger.log("Contexto mudou, buscando perfil ativo")
        }
        catch
        {
            fatalError("Erro moc \(error.localizedDescription)")
        }
    }

    func marcarPerfilAtivo(ativoID: NSManagedObjectID)
    {
//
        
    }
}

extension PerfilPublisher: NSFetchedResultsControllerDelegate
{
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        guard let perfis = controller.fetchedObjects as? [Perfil]
        else { return }
        logger.log("Context has changed, reloading postos")
        self.perfilCVS.value = perfis
    }
}
