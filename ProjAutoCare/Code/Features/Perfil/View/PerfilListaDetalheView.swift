//
//  PerfilListaDetalheView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 29/06/23.
//

import SwiftUI

struct PerfilListaDetalheView: View
{
    @State var edicao = false
    var perfil: Perfil
    
    var body: some View
    {
        HStack
        {
            Text(perfil.nome ?? "")
            Text(perfil.email ?? "")
        }
        .onTapGesture {
            edicao = true
        }
        .navigationDestination(isPresented: $edicao, destination: {
            PerfilScreen(perfil: perfil, isEdit: true)
        })
    }
}
