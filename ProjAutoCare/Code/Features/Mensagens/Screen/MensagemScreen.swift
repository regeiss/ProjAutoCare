//
//  MensagemScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 17/06/23.
//

import SwiftUI

struct MensagemScreen: View
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
                .background(Color("backGroundMain"))
                .scrollContentBackground(.hidden)
                .navigationBarTitle("Mensagens", displayMode: .automatic)
                .toolbar(content: {
                    ToolbarItem {
                        Button { dismiss()}
                    label: { Label("Dismiss", systemImage: "xmark.circle.fill")}
                    }
                    
                }
                )
                Spacer()
            }.background(Color("backGroundMain"))
        }
    }
}
