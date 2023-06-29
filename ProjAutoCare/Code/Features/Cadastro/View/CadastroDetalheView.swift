//
//  CadastroDetalheView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 29/06/23.
//

import SwiftUI

struct CadastroDetalheView: View 
{
    var titulo: String
    
    var body: some View 
    {
        ZStack(alignment: .trailing)
        {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray)
                .frame(height: 100)

            Text(titulo)
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.black)
                .foregroundColor(.white)
                .padding()
        }
    }
}

#Preview {
    CadastroDetalheView()
}
