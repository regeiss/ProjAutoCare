//
//  VersaoAnteriorScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 04/09/23.
//

import SwiftUI

struct VersaoAnteriorScreen: View 
{
    @Environment(\.dismiss) var dismiss
    var body: some View
    {
        NavigationView
        {
            VStack(alignment: .leading)
            {
                Form
                {
                    Section
                    {
                        
                    }
                    Section
                    {
                        
                    }
                }
                .background(Color("backGroundColor"))
                .scrollContentBackground(.hidden)
                .navigationBarTitle("Versões anteriores", displayMode: .automatic)
                .toolbar(content: {
                    ToolbarItem {
                        Button { dismiss()}
                    label: { Label("Dismiss", systemImage: "xmark.circle.fill")}
                    }
                    
                }
                )
                Spacer()
            }.background(Color("backGroundColor"))
        }
    }
}
