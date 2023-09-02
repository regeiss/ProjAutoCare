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
        HStack{
            VStack
            {
                if registro.tipo == "AB"
                {
                    let abastecimento = viewModel.buscaRegistroAbastecimento(id: registro.idTipo ?? UUID())
                    //AbastecimentoListaDetalheView(abastecimento: abastecimento)
                    Text(abastecimento.data!, format: Date.FormatStyle().year().month().day())
                }
                
                else
                {
                    let servicoEfetuado = viewModel.buscaRegistroServico(id: registro.idTipo ?? UUID())
                    //ServicoEfetuadoListaDetalheView(servicoEfetuado: servicoEfetuado)
                    Text(servicoEfetuado.nome ?? "")
                }
            }}
    }
}
