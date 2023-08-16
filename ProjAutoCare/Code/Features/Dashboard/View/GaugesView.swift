//
//  GaugesView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 14/08/23.
//

import SwiftUI

struct GaugesView: View 
{
    var body: some View 
    {
        Text("Lembretes")
        
        HStack
        {
            StyledGauge(current: 10)
            Spacer()
            StyledGauge(current: 40)
            Spacer()
            StyledGauge(current: 90)
        }
        .padding()
        .background(Color("formBackgroundColor"))
        .cornerRadius(12)
    }
}
