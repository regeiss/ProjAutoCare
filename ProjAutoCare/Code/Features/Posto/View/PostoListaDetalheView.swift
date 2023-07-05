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
    // @Binding var edicao: Bool

    var posto: Posto
    
    var body: some View
    {
        HStack
        {
            Text(posto.nome ?? "")
            Text(posto.bandeira ?? "")
        }

    }
}
