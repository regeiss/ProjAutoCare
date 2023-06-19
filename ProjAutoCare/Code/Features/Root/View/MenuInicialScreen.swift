//
//  MenuInicialView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 18/06/23.
//

import SwiftUI

enum Menu: String {
    case abastecimento
    case servico
    case relatorios
    case alertas
    case cadastros 
}

struct MenuInicialScreen: View
{
    var body: some View
    {
        let collections = [
            Collections(id: 0, name: "Abastecimento", image: "gasStation", content: "."),
            Collections(id: 1, name: "Serviço", image: "service", content: "."),
            Collections(id: 2, name: "Relatórios", image: "report", content: "."),
            Collections(id: 3, name: "Alertas", image: "alertas", content: "."),
            Collections(id: 4, name: "Cadastros", image: "config", content: ".")
        ]
        
        let columns = [ GridItem(.flexible(minimum: 230, maximum: .infinity))]
        
        VStack
        {
            ScrollView(.vertical)
            {
                LazyVGrid(columns: columns, alignment: .center, spacing: 5)
                {
                    ForEach(collections) { item in
                    NavigationLink(value: item) {
            Label(item.title, systemImage: item.icon)
                .foregroundColor(.primary)
        }
                        ItemMenuInicialView(collection: item)
                    }
                }.padding([.leading, .trailing])
                // .gesture(drag)
            }.navigationDestination(for: NavigationItem.self) { item in
        switch item.menu {
        case .compass:
            CompassView()
        case .card:
            CardReflectionView()
        case .charts:
            ChartView()
        case .radial:
            RadialLayoutView()
        case .halfsheet:
            HalfSheetView()
        case .gooey:
            GooeyView()
        case .actionbutton:
            ActionButtonView()
        }
    }
        }
    }
}

#Preview {
    MenuInicialScreen()
}
