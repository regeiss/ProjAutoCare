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
    
    @State private var isShowingSheet = false
    @State var showSidebar: Bool = false
    @State private var showSheet = true
    
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
            ])
        ]
    
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
                        MenuInicialScreen()
                            .navigationTitle("AutoCare").foregroundColor(.white) // Color("titleForeGround"))
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading)
                                { Button { showSidebar.toggle()}
                                    label: { Image(systemName: "line.3.horizontal")}}
                                
                                ToolbarItem(placement: .navigationBarTrailing)
                                { Button { isShowingSheet.toggle()}
                                    label: { Image(systemName: "car.2")}}
                        }
                    }
                }
            }.edgesIgnoringSafeArea(.all)
        }
        .welcomeSheet(isPresented: $showSheet, pages: pages)
        .sheet(isPresented: $isShowingSheet)
        {
            VeiculoBottomView()
        }
    }
}
