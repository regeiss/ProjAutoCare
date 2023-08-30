//
//  LogEntriesView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 14/08/23.
//

import SwiftUI

struct LogEntriesView: View
{
    @StateObject var viewModel = RegistroViewModel()
    
    var body: some View
    {
        VStack
        {
        Text("Lembretes")
        List
        {
            ForEach(viewModel.registrosLista) { registro in
                // RegistroListaDetalheView(registro: registro)
                if registro.tipo == "AB"
                {
                    let abastecimento = viewModel.buscaRegistroAbastecimento(id: registro.idTipo ?? UUID())
                    // AbastecimentoListaDetalheView(abastecimento: abastecimento)
                    HStack
                    {
                        Label("gas", systemImage: "fuelpump.circle")
                            .labelStyle(.iconOnly)
                            .imageScale(.large)
                        VStack
                        {
                            HStack
                            {
                                Text("Data: ")
                                Text(abastecimento.data!, format: Date.FormatStyle().year().month().day())
                                Spacer()
                            }
                            
                            HStack
                            {
                                Text("Total: "); Text(String(format: "%.2f", abastecimento.valorTotal).toCurrencyFormat())
                                Spacer()
                                if abastecimento.media > 0 {
                                    Text(String(format: "%.3f", abastecimento.media)); Text(" km/l")}
                            }
                            HStack
                            {
                                Text("Odômetro: ")
                                Text(String(abastecimento.quilometragem).toQuilometrosFormat())
                                Spacer(); Text("Litros: "); Text(String(format: "%.3f", abastecimento.litros))
                            }
                            HStack{Text(abastecimento.nomePosto); Spacer()}
                        }
                    }
                }
                
                else
                {
                    let servicoEfetuado = viewModel.buscaRegistroServico(id: registro.idTipo ?? UUID())
                    // ServicoEfetuadoListaDetalheView(servicoEfetuado: servicoEfetuado)
                    HStack
                    {
                        Text(servicoEfetuado.nome ?? "")
                    }
                }
            }
            
            if $viewModel.registrosLista.isEmpty
            {
                Text("").listRowBackground(Color.clear)
            }
             }
        }
        .background(Color("backGroundColor"))
        .scrollContentBackground(.hidden)
    }
}
