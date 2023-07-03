//
//  AppTheme.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 13/06/23.
//

import Foundation
import SwiftUI

class AppThemeViewModel: ObservableObject
{
    @AppStorage("modoEscuro") var isDarkMode: Bool = true
}

struct DarkModeViewModifier: ViewModifier
{
    @ObservedObject var appThemeViewModel: AppThemeViewModel = AppThemeViewModel()
    
    public func body(content: Content) -> some View
    {
        content
            .preferredColorScheme(appThemeViewModel.isDarkMode ? .dark : appThemeViewModel.isDarkMode == false ? .light : nil)
    }
}

class ToolBarTheme
{
    static func navigationBarColors(background : UIColor?,
       titleColor : UIColor? = nil, tintColor : UIColor? = nil )
    {
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithOpaqueBackground()
        navigationAppearance.backgroundColor = background ?? .clear
        
        navigationAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .black]
        navigationAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .black]
       
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance

        UINavigationBar.appearance().tintColor = tintColor ?? titleColor ?? .black
    }
}
