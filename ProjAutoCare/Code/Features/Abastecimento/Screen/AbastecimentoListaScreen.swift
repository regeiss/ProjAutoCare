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
                }
                .onDelete(perform: delete)
                if $viewModel.abastecimentosLista.isEmpty
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
            AbastecimentoScreen(isEdit: false)
        })
    }
    
    func delete(at offsets: IndexSet)
     {
         for offset in offsets
         {
             let abastecimento = viewModel.abastecimentosLista[offset]
             viewModel.delete(abastecimento: abastecimento)
         }
     }
}
