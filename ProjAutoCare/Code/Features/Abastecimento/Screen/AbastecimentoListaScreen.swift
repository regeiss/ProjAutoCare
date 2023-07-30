//
//  AbastecimentoListaScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/06/23.
//

import SwiftUI

@available(iOS 16.0, *)
struct AbastecimentoListaScreen: View
{
    @StateObject var viewModel = AbastecimentoViewModel()
    @State private var adicao = false
    
    var body: some View
    {
        VStack
        {
            List
            {
                ForEach(viewModel.abastecimentosLista) { abastecimento in
                    HStack
                    {
                        AbastecimentoListaDetalheView(abastecimento: abastecimento)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                      Button(role: .destructive, action: { viewModel.delete(abastecimento: abastecimento)})
                        { Label("Delete", systemImage: "trash")}
                    }
                }
                
                if $viewModel.abastecimentosLista.isEmpty
                {
                    Text("").listRowBackground(Color.clear)
                }
            }
        }.background(Color("backGroundColor"))
        .scrollContentBackground(.hidden)
        .navigationBarTitle("Abastecimento", displayMode: .automatic)
        .toolbar { ToolbarItem(placement: .navigationBarTrailing)
            { Button {
                adicao = true
            }
                label: { Image(systemName: "plus")}}
        }
        .navigationDestination(isPresented: $adicao, destination: {
            AbastecimentoScreen(isEdit: false)
        })
    }
}
