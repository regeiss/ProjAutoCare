//
//  CadastroScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/06/23.
//

import SwiftUI

struct CadastroScreen: View 
{
    @State var categoria = false 
    @State var servico = false
    @State var veiculo = false
    @State var posto = false 

    var body: some View 
    {
        VStack(alignment: .leading)
        {
            VStack()
            {
                MenCadastroDetalheViewuRow(titulo: "Categorias")
                    .onTapGesture
                    {
                        categoria = true 
                    }
                CadastroDetalheView(titulo: "Serviços")
                    .onTapGesture
                    {
                        servico = true 
                    }
                CadastroDetalheView(titulo: "Carros")
                    .onTapGesture
                    {
                        veiculo = true 
                    }
                CadastroDetalheView(titulo: "Postos")
                    .onTapGesture
                    {
                        posto = true 
                    }
                
            }.padding()
            Spacer()
        }
    }
}

#Preview {
    CadastroScreen()
}
