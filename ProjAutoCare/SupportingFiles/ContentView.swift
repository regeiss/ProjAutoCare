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
    init() {
        // UIView.appearance().backgroundColor = UIColor.red
        let navBarAppearance = UINavigationBarAppearance()
        // navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(Color("backGroundMain"))
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
//
    }
    // @Binding var showMenu: Bool
    @State private var isShowingSheet = false
    @State var showSidebar: Bool = false
    
    var body: some View
    {
        
        SideBarStack(sidebarWidth: 185, showSidebar: $showSidebar)
        {
            SideBarView()
        }
        content:
        {

                NavigationStack
                {
                    NavigationLink("Tap me!!!!!") {
                        Text("Destination")
                    }
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
            
        }.edgesIgnoringSafeArea(.all)
    }
}



#Preview
{
    ContentView()
}
