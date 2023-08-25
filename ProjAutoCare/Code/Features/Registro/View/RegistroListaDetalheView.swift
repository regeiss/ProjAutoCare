//
//  RegistroListaDetalheView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 16/08/23.
//

import SwiftUI

struct RegistroListaDetalheView: View
{
    @StateObject var viewModel = RegistroViewModel()
    var registro: Registro
    
    var body: some View
    {
        HStack
        {
            if registro.tipo == "AB"
            {
                let abastecimento = viewModel.buscaRegistro(id: registro.idTipo)
                AbastecimentoListaDetalheView(abastecimento: abastecimento)
            }
            
            else
            {
                let servicoEfetuado = viewModel.buscaRegistro(id: registro.idTipo)
                ServicoEfetuadoListaDetalheView(servicoEfetuado: servicoEfetuado)
            }
        }
    }
}
