//
//  MenuInicialView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 18/06/23.
//

import SwiftUI
import WelcomeSheet

struct MenuInicialScreen: View
{
    var appState = AppState.shared
    var onboardingPages = OnboardingModel()
    @AppStorage("needsAppOnboarding") private var needsAppOnboarding: Bool = true
    @State var veiculoAtual: Veiculo?
    @State var perfilPadrao: Perfil?
    @State var isShowingSheet = false
    @State var showSidebar: Bool = false
    
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
        
        let columns = [ GridItem(.flexible(minimum: 230, maximum: .infinity))]
        
        ZStack
        {
            Color("sidebar").ignoresSafeArea()
            SideBarStack(sidebarWidth: 200, showSidebar: $showSidebar)
            {
                SideBarView()
            }
            
            content:
            {
                NavigationStack
                {
                    ZStack
                    {
                        Color("backGroundColor").ignoresSafeArea()
                        ScrollView(.vertical)
                        {
                            LazyVGrid(columns: columns, alignment: .center, spacing: 5)
                            {
                                ForEach(colecaoMenu) { item in
                                    NavigationLink(value: item) {
                                        ItemMenuInicialView(colecao: item)
                                    }
                                }.padding([.leading, .trailing])
                            }
                            .navigationDestination(for: MenuColecao.self) { item in
                                switch item.menu {
                                case .abastecimento:
                                    AbastecimentoListaScreen()
                                case .servico:
                                    ServicoListaScreen()
                                case .relatorio:
                                    RelatorioListaScreen()
                                case .alerta:
                                    AlertaListaScreen()
                                    // LogEntriesView()
                                case .cadastro:
                                    CadastroListaScreen()
                                case .dashboard:
                                    DashboardScreen()
                                }
                            }
                        }
                    }
                    .navigationTitle("AutoCare").foregroundColor(Color("titleForeGroundColor"))
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading)
                        { Button { showSidebar.toggle()}
                            label: { Image(systemName: "line.3.horizontal")}}
                        ToolbarItem(placement: .navigation)
                        { Text(veiculoAtual?.nome ?? "N/A")
                        }
                        ToolbarItem(placement: .navigation)
                        {Text(perfilPadrao?.nome ?? "N/S")}
                        ToolbarItem(placement: .navigationBarTrailing)
                        { Button { isShowingSheet.toggle()}
                            label: { Image(systemName: "car.2")}}
                    }
                }
            }
        }
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
