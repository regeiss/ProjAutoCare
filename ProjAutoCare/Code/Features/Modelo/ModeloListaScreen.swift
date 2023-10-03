//
//  ModeloListaScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 26/09/23.
//

import SwiftUI

struct ModeloListaScreen: View
{
    @StateObject var viewModel = ModeloViewModel()
    // @State var dados: [DataModelo]?
    @State private var adicao = false
    
    var body: some View
    {
        VStack
        {
            List
            {
                ForEach(viewModel.modeloLista) { modelo in
                    HStack
                    {
                        Text(String(modelo.id))
                        Text(modelo.nome ?? "*")
                    }
                    //                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    //                        Button("Exluir", systemImage: "trash", role: .destructive, action: { viewModel.delete(abastecimento: abastecimento)})
                    //                    }
                }
                
                if $viewModel.modeloLista.isEmpty
                {
                    Text("").listRowBackground(Color.clear)
                }
            }
        }
        .refreshable 
        { viewModel.objectWillChange.send()}
        .background(Color("backGroundColor"))
        .scrollContentBackground(.hidden)
        .navigationBarTitle("Modelos", displayMode: .automatic)
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
