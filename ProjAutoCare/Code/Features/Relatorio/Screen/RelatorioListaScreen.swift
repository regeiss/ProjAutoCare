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
            RelatorioColecao(id: 0, name: "Combustível", image: "gasStation", menu: .combustivel),
            RelatorioColecao(id: 1, name: "Serviços", image: "service", menu: .servico),
            RelatorioColecao(id: 2, name: "Consumo", image: "report", menu: .consumo),
            RelatorioColecao(id: 3, name: "Gráficos", image: "alertas", menu: .graficos)
        ]
        
        let columns = [ GridItem(.flexible(minimum: 230, maximum: .infinity))]
        
        VStack(alignment: .leading)
        {
            ScrollView(.vertical)
            {
                LazyVGrid(columns: columns, alignment: .center, spacing: 2)
                {
                    ForEach(cadastroMenu) { item in
                        NavigationLink(value: item) {
                            RelatorioListaDetalheView(colecao: item)
                        }
                    }.padding([.bottom], 2)
                }.navigationDestination(for: RelatorioColecao.self) { item in
                    switch item.menu {
                    case .combustivel:
                        RelatorioCombustivelScreen()
                    case .servico:
                        RelatorioServicoScreen()
                    case .graficos:
                        RelatorioGraficosScreen()
                    case .consumo:
                        RelatorioConsumoScreen()
                    }
                }.padding()
            }.navigationTitle("Relatórios")
            .background(Color("backGroundColor"))
        }
    }
}
