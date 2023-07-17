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
    init()
    {
       ToolBarTheme.navigationBarColors(background: UIColor(Color("backGroundColor")), titleColor: UIColor(Color("titleForeGroundColor")))
    }
    
    var appState = AppState.shared
    @State private var veiculoAtual: Veiculo?
    @State private var perfilPadrao: Perfil?
    @State private var isShowingSheet = false
    @State var showSidebar: Bool = false
    @State private var showSheet = false
    
    let pages = [
            WelcomeSheetPage(title: "Welcome to Welcome Sheet", rows: [
                WelcomeSheetPageRow(imageSystemName: "rectangle.stack.fill.badge.plus",
                                    title: "Quick Creation",
                                    content: "It's incredibly intuitive. Simply declare an array of pages filled with content."),
                
                WelcomeSheetPageRow(imageSystemName: "slider.horizontal.3",
                                    title: "Highly Customisable",
                                    content: "Match sheet's appearance to your app, link buttons, perform actions after dismissal."),
                
                WelcomeSheetPageRow(imageSystemName: "ipad.and.iphone",
                                    title: "Works out of the box",
                                    content: "Don't worry about various screen sizes. It will look gorgeous on every iOS device.")
            ]),
            
            WelcomeSheetPage(title: "What's New in Translate",
                rows: [
                    WelcomeSheetPageRow(imageSystemName: "platter.2.filled.iphone",
                                        title: "Conversation Views",
                                        content: "Choose a side-by-side or face-to-face conversation view."),

                    WelcomeSheetPageRow(imageSystemName: "mic.badge.plus",
                                        title: "Auto Translate",
                                        content: "Respond in conversations without tapping the microphone button."),

                    WelcomeSheetPageRow(imageSystemName: "iphone",
                                        title: "System-Wide Translation",
                                        content: "Translate selected text anywhere on your iPhone.")
                ],
                mainButtonTitle: "Wassup?"),

            WelcomeSheetPage(title: "Welcome to Reminders",
                rows: [
                    WelcomeSheetPageRow(imageSystemName: "note.text.badge.plus",
                                        accentColor: .green,
                                        title: "Quick Creation",
                                        content: "Simply type, ask Siri, or use the quick toolbar to create reminders."),

                    WelcomeSheetPageRow(imageSystemName: "rectangle.grid.2x2.fill",
                                        accentColor: .init(red: 0.00, green: 0.70, blue: 1.00),
                                        title: "Easy Organizing", content: "Create lists to match your needs and categorize reminders with tags"),

                    WelcomeSheetPageRow(imageSystemName: "lightbulb.fill",
                                        accentColor: .orange,
                                        title: "Suggestions and Smart Lists",
                                        content: "Suggestions help you organize quickly, and smart lists automatically group reminders.")
                ],
                accentColor: .blue),

            WelcomeSheetPage(title: "What's New in Maps",
                rows: [
                    WelcomeSheetPageRow(imageSystemName: "map.fill",
                                        accentColor: .green,
                                        title: "Updated Map Style",
                                        content: "An improved design makes it easier to navigate and explore the map."),

                    WelcomeSheetPageRow(imageSystemName: "mappin.and.ellipse",
                                        accentColor: .red,
                                        title: "All-New Place Cards",
                                        content: "Completely redesigned place cards make it easier to learn about and interact with places."),

                    WelcomeSheetPageRow(imageSystemName: "magnifyingglass",
                                        accentColor: .blue,
                                        title: "Improved Search",
                                        content: "Finding places is now easier with filters and automatic updates when you're browsing results on the map.")
                ],
                accentColor: .pink,
                mainButtonTitle: "Let's go!",
                optionalButtonTitle: "About Apple Maps & Privacy...",
                optionalButtonURL: URL(string: "https://apple.com"))
        ]
    
    var body: some View
    {
        let drag = DragGesture()
            .onEnded
            {
                if $0.translation.width < -100
                {
                    withAnimation{ self.showSidebar = false}
                    print("drag")
                }
            }
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
            .gesture(drag)
        }
        .onAppear { loadViewData()}
        .welcomeSheet(isPresented: $showSheet, pages: pages)
        .sheet(isPresented: $isShowingSheet)
        {
            VeiculoBottomView()
        }
    }
    
    func setAppVars()
     {
         let viewModelPerfil = PerfilViewModel()
         let viewModelVeiculo = VeiculoViewModel()
         let viewModelPosto = PostoViewModel()
         
         viewModelVeiculo.selecionarVeiculoAtivo()
         viewModelPosto.selecionarPostoPadrao()
         viewModelPerfil.selecionarPerfilAtivo()
     }
     
     func loadViewData()
     {
         setAppVars()
         veiculoAtual = appState.veiculoAtivo
         perfilPadrao = appState.perfilAtivo
         print(perfilPadrao?.id?.uuidString as Any)
         print(veiculoAtual?.nome as Any)

     }
}
