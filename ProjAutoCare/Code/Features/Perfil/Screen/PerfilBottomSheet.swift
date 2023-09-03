//
//  PerfilBottomSheet.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 02/09/23.
//

import CoreData
import SwiftUI

@available(iOS 16.0, *)
struct PerfilBottomSheet: View
{
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = PerfilViewModel()
    // @Binding var perfilAtual: Perfil?
    var appState = AppState.shared
    
    var body: some View
    {
        NavigationView
        {
            VStack
            {
                List
                {
                    ForEach(viewModel.perfilLista) { perfil in
                        HStack
                        {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                                .opacity(perfil.ativo == true ? 100 : 0.0)
                            Text(perfil.nome ?? "")
                        }.onTapGesture { marcarPerfilAtivo(ativoID: perfil.objectID)}
                    }
                    
                    if viewModel.perfilLista.isEmpty
                    {
                        Text("").listRowBackground(Color.clear)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationBarTitle("Selecione um perfil", displayMode: .inline )
            .toolbar(content: {
                ToolbarItem {
                    Button { dismiss()}
                label: { Label("Dismiss", systemImage: "xmark.circle.fill")}
                }
            })
        }.presentationDetents([.large])
    }
    
    func marcarPerfilAtivo(ativoID: NSManagedObjectID)
    {
        viewModel.marcarPerfilAtivo(ativoID: ativoID)
        // perfilAtual = appState.perfilAtivo!
    }
}
