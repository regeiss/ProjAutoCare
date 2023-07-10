//
//  AlertaListaScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 02/07/23.
//

import SwiftUI

struct AlertaListaScreen: View
{
    @State var favoriteColor: Int = 0
    var body: some View
    {
        VStack
        {
            Picker("What is your favorite color?", selection: $favoriteColor) {
                Text("Red").tag(0)
                Text("Green").tag(1)
            }
            .pickerStyle(.segmented)
            Spacer()
            Text("Alerta")
        }.navigationTitle("Alertas")
            .background(Color("backGroundColor"))
    }
}
