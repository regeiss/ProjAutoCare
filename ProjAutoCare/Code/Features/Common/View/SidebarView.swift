//
//  SidebarView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 14/06/23.
//

import SwiftUI

struct SideBarView: View
{
    @State var showMenu = false
    
    var body: some View
    {
        VStack(alignment: .leading)
        {
            HStack
            {
                Image(systemName: "rectangle.and.pencil.and.ellipsis")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Text("Login")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top, 100)
            .onTapGesture
            {
                showMenu = false
                // router.toLogin()
            }
            HStack
            {
                Image(systemName: "person")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Text("Perfil")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top, 30)
            .onTapGesture
            {
                showMenu = false
                // router.toListaPerfil()
            }
            HStack
            {
                Image(systemName: "envelope")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Text("Mensagens")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top, 30)
            .onTapGesture
            {
                showMenu = false
                // router.toMenu()
            }
            HStack
            {
                Image(systemName: "gearshape")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Text("Configurações")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top, 30)
            .onTapGesture
            {
                showMenu = false
                SettingsScreen()
            }
            Spacer()
            HStack
            {
                let appBuild = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                Text("WerkstadtG v.")
                Text(appBuild ?? "1.0")
                    .foregroundColor(.gray)
            }.padding([.leading, .bottom])
        }.padding()
        .background(Color(red: 32/255, green: 32/255, blue: 32/255))
    }
}

#Preview {
    SideBarView()
}
