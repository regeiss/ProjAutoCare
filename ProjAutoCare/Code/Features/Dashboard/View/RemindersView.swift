//
//  RemindersView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 14/08/23.
//

import SwiftUI

struct RemindersView: View
{
    var body: some View
    {
        let gradient = Gradient(colors: [.blue, .green, .pink])
        
        HStack
        {
            VStack
            {
                Gauge(value: 0.86) 
                {
                    Text("Speed").foregroundColor(.white)
                }
                .gaugeStyle(.linearCapacity)
                .tint(gradient)
                
                Gauge(value: 0.36)
                {
                    Text("Speed").foregroundColor(.white)
                }
                .gaugeStyle(.linearCapacity)
                .tint(gradient)
                
                Gauge(value: 0.56) 
                {
                    Text("Speed").foregroundColor(.white)
                }
                .gaugeStyle(.linearCapacity)
                .tint(gradient)
            }
        }
        .padding()
        .background(Color("formBackgroundColor"))
        .cornerRadius(12)
    }
}
