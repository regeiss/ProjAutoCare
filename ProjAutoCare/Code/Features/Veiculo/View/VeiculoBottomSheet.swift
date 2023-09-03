//
//  VeiculoBottomView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 17/06/23.
//

import CoreData
import SwiftUI

struct VeiculoBottomSheet: View
{
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = VeiculoViewModel()
    @Binding var veiculoAtual: Veiculo?
    var appState = AppState.shared
    
    var body: some View
    {
        NavigationView
        {
            List
            {
                ForEach(viewModel.veiculosLista) { veiculo in
                    HStack
                    {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                            .opacity(veiculo.ativo == true ? 100 : 0.0)
                        Text(String(veiculo.nome ?? ""))
                        Text(" "); Text(String(veiculo.placa ?? ""))
                        Text(" "); Text(String(veiculo.ano))
                    }.onTapGesture { marcarVeiculoComoAtivo(ativoID: veiculo.objectID)}
                    
                    if viewModel.veiculosLista.isEmpty
                    {
                        Text("").listRowBackground(Color.clear)
                    }
                }
                Spacer()
            }
            .scrollContentBackground(.hidden)
            .navigationBarTitle("Selecione um veículo", displayMode: .inline )
            .toolbar(content: {
                ToolbarItem {
                    Button { dismiss()}
                label: { Label("Dismiss", systemImage: "xmark.circle.fill")}
                }
            })
        }.presentationDetents([.medium])
    }
    
    func marcarVeiculoComoAtivo(ativoID: NSManagedObjectID)
    {
        viewModel.marcarVeiculoAtivo(ativoID: ativoID)
        veiculoAtual = appState.veiculoAtivo!
    }
}
