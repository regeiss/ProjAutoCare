//
//  PerfilListaDetalheView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 29/06/23.
//

import SwiftUI

@available(iOS 16.0, *)
struct PerfilListaDetalheView: View
{
    @ObservedObject var viewModel: PerfilViewModel
    @State var edicao = false
    var perfil: Perfil
    
    var body: some View
    {
        HStack
        {
            Text(perfil.nome ?? "")
            Text(perfil.email ?? "")
        }
        .onTapGesture { edicao = true }
        .navigationDestination(isPresented: $edicao, destination: {
            PerfilReadScreen(viewModel: viewModel, perfil: perfil)
        })
    }
}
