//
//  SidebarView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 14/06/23.
//

import SwiftUI

struct SideBarView: View
{
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = PerfilViewModel()
    @State var showMenu = false
    @State var showConfigSheet = false
    @State var showPerfilSheet = false
    @State var showMensagemSheet = false
    
    var body: some View
    {
        let drag = DragGesture()
            .onEnded
            {
                if $0.translation.width < -100
                {
                    withAnimation{ dismiss()}
                }
            }
        
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
                showPerfilSheet = true 
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
                showMensagemSheet = true
            }
            HStack
            {
                Image(systemName: "shippingbox.and.arrow.backward")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Text("Versões ant.")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top, 30)
            .onTapGesture
            {
                showMenu = false
                showMensagemSheet = true
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
                showConfigSheet = true
            }
            Spacer()
            HStack
            {
                let versaoApp = Bundle.main.appName! + " - " + Bundle.main.appVersion! + Bundle.main.buildNumber!
                
                Text(versaoApp)
                    .font(.system(size: 11, weight: .thin))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
            }.padding([.leading, .bottom])
        }
        .gesture(drag)
        .background(Color("sidebar"))
        .sheet(isPresented: $showConfigSheet)
        {
            SettingsScreen()
        }
        .sheet(isPresented: $showPerfilSheet)
        {
            PerfilListaScreen()
        }
        .sheet(isPresented: $showMensagemSheet)
        {
            MensagemScreen()
        }
    }
}

extension Bundle {
    var appName: String? {
        return object(forInfoDictionaryKey: "CFBundleName") as? String
    }
    
    var appVersion: String? {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    var buildNumber: String? {
        return object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
}
