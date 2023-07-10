//
//  RelatorioListaScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/06/23.
//

import SwiftUI

struct RelatorioListaScreen: View
{
    @State var categoria = false
    @State var servico = false
    @State var veiculo = false
    @State var posto = false
    
    var body: some View
    {
        let cadastroMenu = [
            RelatorioColecao(id: 0, name: "Categorias", image: "gasStation", menu: .categoria),
            RelatorioColecao(id: 1, name: "Serviços", image: "service", menu: .servico),
            RelatorioColecao(id: 2, name: "Veículos", image: "report", menu: .veiculo),
            RelatorioColecao(id: 3, name: "Postos", image: "alertas", menu: .posto),
            RelatorioColecao(id: 4, name: "Perfil", image: "config", menu: .perfil)
        ]
        
        let columns = [ GridItem(.flexible(minimum: 230, maximum: .infinity))]
        
        VStack(alignment: .leading)
        {
            ScrollView(.vertical)
            {
                LazyVGrid(columns: columns, alignment: .center, spacing: 5)
                {
                    ForEach(cadastroMenu) { item in
                        NavigationLink(value: item) {
                            RelatorioListaDetalheView(colecao: item)
                        }
                    }.padding([.leading, .trailing])
                }.navigationDestination(for: CadastroColecao.self) { item in
                    switch item.menu {
                    case .categoria:
                        CategoriaListaScreen()
                    case .servico:
                        ServicoListaScreen()
                    case .veiculo:
                        VeiculoListaScreen()
                    case .posto:
                        PostoListaScreen()
                    case .perfil:
                        PerfilListaScreen()
                    }
                }.padding()
            }.navigationTitle("Relatórios")
            .background(Color("backGroundColor"))
        }
    }
}
