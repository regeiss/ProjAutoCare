//
//  MenuInicialView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 18/06/23.
//

import SwiftUI
import WelcomeSheet
import SwiftUICoordinator

struct MenuInicialScreen<Coordinator: Routing>: View
{
    @AppStorage("needsAppOnboarding") private var needsAppOnboarding: Bool = true
    @State var veiculoAtual: Veiculo?
    @State var perfilPadrao: Perfil?
    @State var isShowingSheet = false
    @State var showSidebar: Bool = false
    
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewModel = ViewModel<Coordinator>()
    
    var appState = AppState.shared
    var onboardingPages = OnboardingModel()
    
    init()
    {
        ToolBarTheme.navigationBarColors(background: UIColor(Color("backGroundColor")), titleColor: UIColor(Color("titleForeGroundColor")))
    }
    
    var body: some View
    {
        let colecaoMenu = [
            MenuColecao(id: 0, name: "Abastecimento", image: "gasStation", menu: .abastecimento),
            MenuColecao(id: 1, name: "Serviço", image: "service", menu: .servico),
            MenuColecao(id: 2, name: "Relatórios", image: "report", menu: .relatorio),
            MenuColecao(id: 3, name: "Alertas", image: "alertas", menu: .alerta),
            MenuColecao(id: 4, name: "Cadastros", image: "config", menu: .cadastro),
            MenuColecao(id: 5, name: "Dashboard", image: "config", menu: .dashboard)
        ]
                
        ZStack
        {
            Color("sidebar").ignoresSafeArea()
            SideBarStack(sidebarWidth: 200, showSidebar: $showSidebar)
            {
                SideBarView()
            }
            
        content:
            {
                ZStack
                {
                    Color("backGroundColor").ignoresSafeArea()
                    List
                    {
                        ForEach(colecaoMenu) { item in
                            
                            MenuInicialItemView(colecao: item)
                                .onTapGesture {
                                    viewModel.didTapBuiltIn(id: item.id)
                                }
                            
                        }.padding([.leading, .trailing])
                        
                    }.onAppear { viewModel.coordinator = coordinator }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading)
                    { Button { showSidebar.toggle()}
                        label: { Image(systemName: "line.3.horizontal")}}
                    ToolbarItem(placement: .navigation)
                    { Text(veiculoAtual?.nome ?? "N/A")}
                    ToolbarItem(placement: .navigation)
                    {Text(perfilPadrao?.nome ?? "N/S")}
                    ToolbarItem(placement: .navigationBarTrailing)
                    { Button { isShowingSheet.toggle()}
                        label: { Image(systemName: "car.2")}}
                }
            }.background(Color("backGroundColor"))
        }
        .environment(\.managedObjectContext, ProjAutoCareApp.persistenceController.container.viewContext)
        .modifier(DarkModeViewModifier())
        .environment(\.locale, Locale(identifier: "pt_BR"))
        .onAppear { loadViewData()}
        .welcomeSheet(isPresented: $needsAppOnboarding, pages: onboardingPages.pages)
        .sheet(isPresented: $isShowingSheet)
        {
            VeiculoBottomSheet(veiculoAtual: $veiculoAtual)
        }
    }
    
    func loadViewData()
    {
        setAppVars()
        veiculoAtual = appState.veiculoAtivo
        perfilPadrao = appState.perfilAtivo
    }
    
    // Tratar a insercao dos itens padrao
    func setAppVars()
    {
        let viewModelPerfil = PerfilViewModel()
        let viewModelVeiculo = VeiculoViewModel()
        let viewModelPosto = PostoViewModel()
        
        viewModelVeiculo.selecionarVeiculoAtivo()
        viewModelPosto.selecionarPostoPadrao()
        viewModelPerfil.selecionarPerfilAtivo()
    }
}

extension MenuInicialScreen
{
    @MainActor class ViewModel<R: Routing>: ObservableObject
    {
        var coordinator: R?
        
        func didTapBuiltIn(id: Int) 
        {
            switch id
            {
            case 0:
                coordinator?.handle(MenuPrincipalAction.abastecimento)
            case 1:
                coordinator?.handle(MenuPrincipalAction.servico)
            case 2:
                coordinator?.handle(MenuPrincipalAction.relatorios)
            case 3:
                coordinator?.handle(MenuPrincipalAction.alertas)
            case 4:
                coordinator?.handle(MenuPrincipalAction.cadastros)
            case 5:
                coordinator?.handle(MenuPrincipalAction.dashboard)
            default:
                coordinator?.handle(MenuPrincipalAction.abastecimento)
            }
            
        }
    }
}
