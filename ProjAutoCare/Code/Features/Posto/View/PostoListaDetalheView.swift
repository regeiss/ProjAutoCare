//
//  PostoListaDetalheView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 26/06/23.
//

import SwiftUI

struct PostoListaDetalheView: View
{
    @State var edicao = false
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
            PostoScreen(posto: posto, isEdit: true)
        })
//        .onTapGesture {
//            pilot.push(.edicaoPosto(posto: posto))
//        }
    }
}
