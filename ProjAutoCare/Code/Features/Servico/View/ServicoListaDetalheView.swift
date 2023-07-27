//
//  ServicoListaDetalheView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 09/07/23.
//

import SwiftUI

@available(iOS 16.0, *)
struct ServicoListaDetalheView: View
{
    @ObservedObject var viewModel: ServicoViewModel
    @State var edicao: Bool = false
    var servico: Servico
    
    var body: some View
    {
        HStack
        {
            Text(servico.nome ?? "")
        }
        .onTapGesture {
            edicao = true
        }
        .navigationDestination(isPresented: $edicao, destination: {
            ServicoEditScreen(viewModel: viewModel, servico: servico)
        })
    }
}
