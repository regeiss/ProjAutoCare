//
//  CadastroDetalheView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 29/06/23.
//

import SwiftUI

struct CadastroDetalheView: View 
{
    var colecao: CadastroColecao
    
    var body: some View 
    {
        ZStack(alignment: .trailing)
        {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("BotaoMenuColor"))
                .frame(height: 110)

            Text(colecao.name)
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.heavy)
                .foregroundColor(Color("TextoBotaoMenuColor"))
                .offset(x: 1.0, y: 10)
                .padding()
        }
    }
}
