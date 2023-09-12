//
//  MarcaScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 08/09/23.
//

import SwiftUI

struct MarcaScreen: View
{
    @StateObject private var viewModel = MarcaViewModelImpl(service: NetworkService())
    @State var dados: [Datum]?
    
    var body: some View
    {
        VStack
        {
            ScrollView(.vertical)
            {
                switch viewModel.state
                {
                case .loading:
                    LoadingView(text: "Buscando")
                    
                case .success(let data):
                    VStack
                    {
                        ForEach(data.data, id: \.id) { marca in
                            Text(marca.name)
                        }
                       
                    }.padding()
                    
                case .failed(let error):
                    ErrorView(erro: error)
                    
                default: EmptyView()
                }
            }.task { await viewModel.getAllMarcas() }
                .alert("Error", isPresented: $viewModel.hasError, presenting: viewModel.state) { detail in Button("Retry", role: .destructive)
                    { Task { await viewModel.getAllMarcas()}}} message: { detail in if case let .failed(error) = detail { Text(error.localizedDescription)}}
            
        }
    }
}
