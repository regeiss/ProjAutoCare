//
//  CadastroScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/06/23.
//

import SwiftUI

struct CadastroScreen: View 
{
    var body: some View 
    {
        VStack(alignment: .leading)
        {
            VStack()
            {
                MenuRow(titulo: "Categorias")
                    .onTapGesture
                    {
                        router.toListaCategoria()
                    }
                MenuRow(titulo: "Serviços")
                    .onTapGesture
                    {
                        router.toListaServico()
                    }
                MenuRow(titulo: "Carros")
                    .onTapGesture
                    {
                        router.toListaCarro()
                    }
                MenuRow(titulo: "Postos")
                    .onTapGesture
                    {
                        router.toListaPosto()
                    }
                
            }.padding()
            Spacer()
        }
    }
}

#Preview {
    CadastroScreen()
}
