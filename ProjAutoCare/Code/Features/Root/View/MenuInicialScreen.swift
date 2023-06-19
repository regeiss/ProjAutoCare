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
        let collections = [
            Collections(id: 0, name: "Abastecimento", image: "gasStation", content: "."),
            Collections(id: 1, name: "Serviço", image: "service", content: "."),
            Collections(id: 2, name: "Relatórios", image: "report", content: "."),
            Collections(id: 3, name: "Alertas", image: "alertas", content: "."),
            Collections(id: 4, name: "Cadastros", image: "config", content: ".")
        ]
        
        //            let drag = DragGesture()
        //                .onEnded
        //            {
        //                if $0.translation.width < -100
        //                {
        //                    withAnimation{ self.showMenu = false}
        //                }
        //            }
        
        let columns = [ GridItem(.flexible(minimum: 230, maximum: .infinity))]
        
        VStack
        {
            ScrollView(.vertical)
            {
                LazyVGrid(columns: columns, alignment: .center, spacing: 5)
                {
                    ForEach(collections) { item in
                        ItemMenuInicialView(collection: item)
                    }
                }.padding([.leading, .trailing])
                // .gesture(drag)
            }
        }
    }
}

#Preview {
    MenuInicialScreen()
}
