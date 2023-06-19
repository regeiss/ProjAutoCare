//
//  ContentView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 12/06/23.
//

import SwiftUI
import SwiftData

struct ContentView: View
{
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
                        Color("backGroundMain").ignoresSafeArea()
                        MenuInicialScreen()
                        .navigationTitle("AutoCare")
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

#Preview
{
    ContentView()
}
