//
//  MenuInicialItemView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 18/06/23.
//

import SwiftUI

struct MenuInicialItemView: View
{
    var colecao: MenuColecao
    let height: CGFloat = 110
    var body: some View
    {
        ZStack(alignment: .bottomTrailing)
        {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("BotaoMenuColor"))
                .frame(height: colecao.name == "Abastecimento" ? 150 : height)
            
            Text(colecao.name)
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.heavy)
                .foregroundColor(Color("TextoBotaoMenuColor"))
                .offset(x: 1.0, y: 10)
                .padding()
            
//                            if collection.name == "Abastecimento"
//                            {
//                                UltimoAbastecimentoView().offset(x: -10, y: -50)
//                            }
        }.frame(minWidth: 230, maxWidth: .infinity, minHeight: height, maxHeight: 150)
    }
}
