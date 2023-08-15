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
        HStack
        {
            StyledGauge(current: 10)
            Spacer()
            StyledGauge(current: 10)
            Spacer()
            StyledGauge(current: 10)
        }
        .padding()
        .background(Color("backGroundColor"))
    }
}

//#Preview {
//    DashboardScreen()
//}
