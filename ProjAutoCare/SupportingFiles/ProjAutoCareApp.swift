//
//  ProjAutoCareApp.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 12/06/23.
//

import SwiftUI
import CoreData

@available(iOS 16.0, *)
@main
struct ProjAutoCareApp: App
{
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.managedObjectContext) private var moc: NSManagedObjectContext
    @AppStorage("contextSet") private var contextSet: Bool = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    
    static let persistenceController = PersistenceController.shared
    
    var body: some Scene
    {
        WindowGroup
        {
            
        }
        .onChange(of: scenePhase)
        {
            switch scenePhase
            {
            case .active:
                prepareAppContext()
            case .inactive:
                print("inactive")
            case .background:
                saveContext()
            @unknown default:
                fatalError()
            }
        }
    }
    
    final class SceneDelegate: NSObject, UIWindowSceneDelegate 
    {
        var dependencyContainer = DependencyContainer()
        
        func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) 
        {
            guard let window = (scene as? UIWindowScene)?.windows.first 
            else { return }
            
            let appCoordinator = dependencyContainer.makeAppCoordinator(window: window)
            dependencyContainer.set(appCoordinator)
            
            let coordinator = dependencyContainer.makeMenuPrincipalCoordinator(parent: appCoordinator)
            appCoordinator.start(with: coordinator)
        }
        
        func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) 
        {
            guard
                let url = URLContexts.first?.url,
                let deepLink = try? dependencyContainer.deepLinkHandler.link(for: url),
                let params = try? dependencyContainer.deepLinkHandler.params(for: url, and: deepLink.params)
            else { return }
            
            dependencyContainer.appCoordinator?.handle(deepLink, with: params)
        }
    }

    class AppDelegate: NSObject, UIApplicationDelegate 
    {
        func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
            let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
            sceneConfig.delegateClass = SceneDelegate.self
            return sceneConfig
        }
    }
    
    func prepareAppContext()
    {
        guard contextSet == false
        else { return }
        
        Task
        {
            try await MarcaDecoder.shared.batchDeleteMarcas()
            try await MarcaDecoder.shared.fetchMarcas()
            try await ModeloDecoder.shared.batchDeleteModelos()
            try await ModeloDecoder.shared.fetchModelos()
            try await ModeloDecoder.shared.ajustaMarcaModelo()
        }
        
        let viewModelPerfil = PerfilViewModel()
        let viewModelVeiculo = VeiculoViewModel()
        let viewModelPosto = PostoViewModel()
        let viewModelCategoria = CategoriaViewModel()
        let viewModelServico = ServicoViewModel()
        
        viewModelPerfil.inserePadrao()
        viewModelVeiculo.inserePadrao()
        viewModelPosto.inserePadrao()
        viewModelCategoria.inserePadrao()
        viewModelServico.inserePadrao()
        
        contextSet = true
    }
    
    func saveContext()
    {
        let context = moc
        if context.hasChanges
        {
            do
            {
                try context.save()
            }
            catch
            {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
