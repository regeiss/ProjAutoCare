//
//  SidebarView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 14/06/23.
//

import SwiftUI

struct SideBarView: View
{
    @StateObject var viewModel = PerfilViewModel()
    @State var showMenu = false
    @State var showConfigSheet = false
    @State var showPerfilSheet = false
    @State var showMensagemSheet = false
    
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
                Text(Bundle.main.copyright)
                    .font(.system(size: 10, weight: .thin))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
            }.padding([.leading, .bottom])
        }
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

extension Bundle
{
    public var appName: String           { getInfo("CFBundleName") }
    public var displayName: String       { getInfo("CFBundleDisplayName") }
    public var language: String          { getInfo("CFBundleDevelopmentRegion") }
    public var identifier: String        { getInfo("CFBundleIdentifier") }
    public var copyright: String         { getInfo("NSHumanReadableCopyright").replacingOccurrences(of: "\\\\n", with: "\n") }
    public var appBuild: String          { getInfo("CFBundleVersion") }
    public var appVersionLong: String    { getInfo("CFBundleShortVersionString") }
    
    fileprivate func getInfo(_ str: String) -> String { infoDictionary?[str] as? String ?? "⚠️" }
}
