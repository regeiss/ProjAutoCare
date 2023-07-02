//
//  MenuInicialView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 18/06/23.
//

import SwiftUI

struct MenuInicialScreen: View
{
    var body: some View
    {
        let colecaoMenu = [
            MenuColecao(id: 0, name: "Abastecimento", image: "gasStation", menu: .abastecimento),
            MenuColecao(id: 1, name: "Serviço", image: "service", menu: .servico),
            MenuColecao(id: 2, name: "Relatórios", image: "report", menu: .relatorio),
            MenuColecao(id: 3, name: "Alertas", image: "alertas", menu: .alerta),
            MenuColecao(id: 4, name: "Cadastros", image: "config", menu: .cadastro)
        ]
        
        let columns = [ GridItem(.flexible(minimum: 230, maximum: .infinity))]
        
        VStack
        {
            ScrollView(.vertical)
            {
                LazyVGrid(columns: columns, alignment: .center, spacing: 5)
                {
                    ForEach(colecaoMenu) { item in
                        NavigationLink(value: item) {
                            
                            ItemMenuInicialView(colecao: item)
                        }
                    }.padding([.leading, .trailing])
                }.navigationDestination(for: MenuColecao.self) { item in
                    switch item.menu {
                    case .abastecimento:
                        AbastecimentoListaScreen()
                    case .servico:
                        ServicoListaScreen()
                    case .relatorio:
                        RelatorioListaScreen()
                    case .alerta:
                        AlertaListaScreen()
                    case .cadastro:
                        CadastroListaScreen()
                    }
                }
            }
        }
    }
}
