//
//  ServicoEfetuadoListaDetalheView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 14/07/23.
//

import SwiftUI

@available(iOS 16.0, *)
struct ServicoEfetuadoListaDetalheView: View
{
    @ObservedObject var viewModel: ServicoEfetuadoViewModel
    @State var edicao: Bool = false
    var servicoEfetuado: ServicoEfetuado
    
    var body: some View
    {
        HStack
        {
            Text(servicoEfetuado.nome ?? "")
        }
        .onTapGesture {
            edicao = true
        }
        .navigationDestination(isPresented: $edicao, destination: {
            ServicoEfetuadoScreen(viewModel: viewModel, servicoEfetuado: servicoEfetuado, isEdit: true)
        })
    }
}
