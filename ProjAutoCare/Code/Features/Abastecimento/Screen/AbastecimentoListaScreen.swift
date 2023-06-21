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
    @Query private var abastecimento: [AbastecimentoModel]
    @State private var adicao = false

    var body: some View
    {
        VStack{
            List
            {
                ForEach(abastecimento) { abastecimento in
                    HStack
                    {
                        AbastecimentoListaDetalheView(abastecimento: abastecimento)
                    }
                }
                // .onDelete(perform: $abastecimento.remove(atOffsets:))
                if abastecimento.isEmpty
                {
                    Text("").listRowBackground(Color.clear)
                }
            }
        }.background(Color("backGroundMain"))
            .scrollContentBackground(.hidden)
            .navigationBarTitle("Abastecimento", displayMode: .automatic)
            .toolbar { ToolbarItem(placement: .navigationBarTrailing)
                { Button {
                    adicao = true
                }
                    label: { Image(systemName: "plus")}}
            }
            .navigationDestination(isPresented: $adicao, destination: {
                AbastecimentoScreen(abastecimento: abastecimento, isEdit: false)
            })
    }
}

#Preview {
    AbastecimentoListaScreen()
}
