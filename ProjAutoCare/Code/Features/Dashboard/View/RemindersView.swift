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
        VStack
        {
            Gauge(value: 16) {
            
                Text("Speed")
            }
            Gauge(value: 36) {
                
                Text("Speed")
            }
            Gauge(value: 56) {
                
                Text("Speed")
            }
        }.padding()
    }
}

//#Preview {
//    RemindersView()
//}
