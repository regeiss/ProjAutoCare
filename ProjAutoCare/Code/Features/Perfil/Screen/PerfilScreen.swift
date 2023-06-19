//
//  PerfilScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 16/06/23.
//

import SwiftUI

struct PerfilScreen: View
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
                }
                .background(Color("backGroundMain"))
                .scrollContentBackground(.hidden)
                .navigationBarTitle("Perfil", displayMode: .automatic)
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

#Preview {
    PerfilScreen()
}
