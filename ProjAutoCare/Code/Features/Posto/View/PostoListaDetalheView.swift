//
//  PostoListaDetalheView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 26/06/23.
//

import SwiftUI

@available(iOS 16.0, *)
struct PostoListaDetalheView: View
{
    @ObservedObject var viewModel: PostoViewModel
    @State var consulta: Bool = false
    var posto: Posto
    
    var body: some View
    {
        HStack
        {
            Text(posto.nome ?? "")
            Text(posto.bandeira ?? "")
        }
        .onTapGesture {
            consulta = true
        }
        .navigationDestination(isPresented: $consulta, destination: {
            PostoReadScreen(viewModel: viewModel, posto: posto)
        })
    }
}
