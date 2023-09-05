//
//  LogEntriesView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 14/08/23.
//

import SwiftUI

struct LogEntriesView: View
{
    @StateObject var viewModel = RegistroViewModel()
    
    var body: some View
    {
        HStack
        {
            List
            {
                ForEach(viewModel.registrosLista) { registro in
                    RegistroListaDetalheView(registro: registro)
                }
                
                if $viewModel.registrosLista.isEmpty {
                    Text("").listRowBackground(Color.clear)
                }
            }
            .listStyle(PlainListStyle())
            .background(Color("backGroundColor"))
            .scrollContentBackground(.hidden)
        }
        .background(Color("formBackgroundColor"))
        .cornerRadius(12)
    }
}
