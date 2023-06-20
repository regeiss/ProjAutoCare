//
//  AbastecimentoListaScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/06/23.
//

import SwiftUI
import SwiftData

@available(iOS 16.0, *)
struct AbastecimentoListaScreen: View
{
    @Query private var abastecimento: [Abastecimento]
    @State private var adicao = false

    var body: some View
    {
        Text("Abastecimento")
       List
       {
           ForEach(abastecimentos) { abastecimento in
               HStack
               {
                   AbastecimentoListaDetalheView(abastecimento: abastecimento)
               }
           }
           .onDelete(perform: $abastecimentos.remove(atOffsets:))
           if abastecimentos.isEmpty
           {
               Text("").listRowBackground(Color.clear)
           }
       }
       .background(Color("backGroundMain"))
       .scrollContentBackground(.hidden)
       .navigationBarTitle("Abastecimento", displayMode: .automatic)
       .toolbar { ToolbarItem(placement: .navigationBarTrailing)
           { Button {
               adicao = true 
           }
               label: { Image(systemName: "plus")}}
       }
       .navigationDestination(isPresented: $adicao, destination: {
            AbastecimetnoScreen()
        })
    }
}

#Preview {
    AbastecimentoListaScreen()
}
