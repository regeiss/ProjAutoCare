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
    @Environment(\.modelContext) var modelContext
    @State private var adicao = false
    @State var viewModel = AbastecimentoViewModel()
    
    var body: some View
    {
        VStack
        {
            List
            {
                ForEach(viewModel.abastecimentosLista) { abastecimento in
                    HStack
                    {
                        AbastecimentoListaDetalheView(abastecimento: viewModel.abastecimentoLista)
                    }
                }
                // .onDelete(perform: $abastecimento.remove(atOffsets:))
                if viewModel.abastecimento.isEmpty
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
                AbastecimentoScreen()
            })
            .onAppear {
                viewModel.modelContext = modelContext
                viewModel.fetch()
            }
    }
}

#Preview {
    AbastecimentoListaScreen()
}
