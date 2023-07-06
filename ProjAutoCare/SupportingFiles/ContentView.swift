//
//  ContentView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 12/06/23.
//

import SwiftUI

struct ContentView: View
{
    init()
    {
       ToolBarTheme.navigationBarColors(background: UIColor(Color("backGroundColor")), titleColor: UIColor(Color("titleForeGroundColor")))
    }
    
    @State private var isShowingSheet = false
    @State var showSidebar: Bool = false
    // let sizes = Sizes()
    
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
        }.sheet(isPresented: $isShowingSheet)
        {
            VeiculoBottomView()
        }
    }
}
