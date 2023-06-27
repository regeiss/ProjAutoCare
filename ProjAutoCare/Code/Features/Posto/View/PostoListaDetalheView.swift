//
//  PostoListaDetalheView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 26/06/23.
//

import SwiftUI

struct PostoListaDetalheView: View
{
    var posto: Posto
    
    var body: some View
    {
        HStack
        {
            Text(posto.nome ?? "")
            Text(posto.bandeira ?? "")
        }
//        .onTapGesture {
//            pilot.push(.edicaoPosto(posto: posto))
//        }
    }
}
