//
//  ContentView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 12/06/23.
//  https://github.com/MAJKFL/Welcome-Sheet

import SwiftUI
import WelcomeSheet

struct ContentView: View
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
                        MenuInicialScreen(showSidebar: $showSidebar)
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
            .edgesIgnoringSafeArea(.all)
        }
        .environment(\.locale, Locale(identifier: "pt_BR"))
        .onAppear { loadViewData()}
        .welcomeSheet(isPresented: $needsAppOnboarding, pages: onboardingPages.pages)
        .sheet(isPresented: $isShowingSheet)
        {
            VeiculoBottomView(veiculoAtual: $veiculoAtual)
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
