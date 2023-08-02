//
//  RelatorioCombustivelScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 31/07/23.
//

import SwiftUI

struct RelatorioCombustivelScreen: View
{
    var body: some View
    {
        VStack
        {
            List {

              }.scrollContentBackground(.hidden)
        }
        .toolbar {

            ToolbarItem(placement: .navigationBarTrailing)
            { Button {
                
            }
            label: { Image(systemName: "line.3.horizontal.decrease.circle")}
            }
        }
        .background(Color("backGroundColor"))
        .navigationTitle("Combustível")
        .navigationBarTitleDisplayMode(.large)
    }
}
