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
    @State var edicao: Bool = false
    var posto: Posto
    
    var body: some View
    {
        HStack
        {
            Text(posto.nome ?? "")
            Text(posto.bandeira ?? "")
        }
        .onTapGesture {
            edicao = true
        }
        .navigationDestination(isPresented: $edicao, destination: {
            PostoScreen(viewModel: viewModel, posto: posto, isEdit: true)
        })
    }
}
