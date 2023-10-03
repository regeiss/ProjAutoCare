//
//  MarcaScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 08/09/23.
//

import SwiftUI

struct MarcaListaScreen: View
{
    @StateObject var viewModel = MarcaViewModel()
    // @State var dados: [DataMarca]?
    @State private var adicao = false
    
    var body: some View
    {
        VStack
        {
            List
            {
                ForEach(viewModel.marcaLista) { marca in
                    HStack
                    {
                        Text(String(marca.id))
                        Text(marca.nome ?? "*")
                    }
                    //                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    //                        Button("Exluir", systemImage: "trash", role: .destructive, action: { viewModel.delete(abastecimento: abastecimento)})
                    //                    }
                }
                
                if $viewModel.marcaLista.isEmpty
                {
                    Text("").listRowBackground(Color.clear)
                }
            }
        }.refreshable
        { viewModel.objectWillChange.send()}
        .background(Color("backGroundColor"))
        .scrollContentBackground(.hidden)
        .navigationBarTitle("Marcas", displayMode: .automatic)
        .toolbar { ToolbarItem(placement: .navigationBarTrailing)
            { Button {
                adicao = true
            }
                label: { Image(systemName: "plus")}}
        }
        //            .navigationDestination(isPresented: $adicao, destination: {
        //                AbastecimentoAddScreen(isEdit: false)
        //            })
    }
}
