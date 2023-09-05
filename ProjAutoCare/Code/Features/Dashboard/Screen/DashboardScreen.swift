//
//  DashboardScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 14/08/23.
//

import SwiftUI

struct DashboardScreen: View 
{
    var body: some View 
    {
        VStack
        {
            GaugesView()
            
            LogEntriesView()
            RemindersView()
        }
        .padding()
        .background(Color("backGroundColor"))
        .navigationBarTitle("Dashboard", displayMode: .large)
    }
}
