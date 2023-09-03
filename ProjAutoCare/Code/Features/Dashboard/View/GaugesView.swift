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
            VStack
            {
                StyledGauge(current: 10)
                Text("Média")
                
            }
            Spacer()
            
            VStack
            {
                StyledGauge(current: 40)
                Text("Manutenção")
                 
            }
            Spacer()
            
            VStack
            {
                StyledGauge(current: 90)
                Text("Avisos")
            }
        }
        .padding()
        .background(Color("formBackgroundColor"))
        .cornerRadius(12)
    }
}
