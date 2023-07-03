//
//  PerfilListaScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 02/07/23.
//

import SwiftUI

struct PerfilListaScreen: View
{
    @StateObject private var viewModel = PerfilViewModel()
    
    var body: some View
    {
        VStack
        {
            List
            {
                ForEach(viewModel.perfilLista, id: \.self) { perfil in
                    HStack
                    {
                        Text(String(perfil.nome ?? ""))
                        Spacer()
                        Text(perfil.ativo ? "ativo" : " ").foregroundColor(.blue)
                    }.onTapGesture
                    {
                        editPerfil(perfil: perfil)
                    }
                }.onDelete(perform: deletePerfil)
                
            }
            Spacer()
        }
    }
    
    func editPerfil(perfil: Perfil)
    {
        // router.toPerfil(perfil: perfil, isEdit: true)
    }
    
    func deletePerfil(at offsets: IndexSet)
    {
        for offset in offsets
        {
            let perfil = viewModel.perfilLista[offset]
            viewModel.delete(perfil: perfil)
        }
    }
}
