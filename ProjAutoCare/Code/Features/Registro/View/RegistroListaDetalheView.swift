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
        VStack
        {
            if registro.tipo == "AB"
            {
                let abastecimento = viewModel.buscaRegistroAbastecimento(id: registro.idTipo ?? UUID())
                AbastecimentoListaDetalheView<AbastecimentoCoordinator>(abastecimento: abastecimento)
            }
            else
            {
                let servicoEfetuado = viewModel.buscaRegistroServico(id: registro.idTipo ?? UUID())
                ServicoEfetuadoListaDetalheView(servicoEfetuado: servicoEfetuado)
            }
        }
    }
}
