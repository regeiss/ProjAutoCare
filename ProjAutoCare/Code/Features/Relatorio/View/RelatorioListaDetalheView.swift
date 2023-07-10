//
//  RelatorioDetalheView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 10/07/23.
//

import SwiftUI

struct RelatorioListaDetalheView: View
{
    var colecao: RelatorioColecao
    let height: CGFloat = 110
    
    var body: some View
    {
        ZStack(alignment: .bottomTrailing)
        {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("BotaoMenuColor"))
                .frame(height: height)
            
            Text(colecao.name)
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.heavy)
                .foregroundColor(Color("TextoBotaoMenuColor"))
                .offset(x: 1.0, y: 10)
                .padding()
        }.frame(minWidth: 230, maxWidth: .infinity, minHeight: height, maxHeight: 150)
    }
}
