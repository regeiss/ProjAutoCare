//
//  VeiculoBottomView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 17/06/23.
//
import CoreData
import SwiftUI

struct VeiculoBottomView: View
{
    @Environment(\.dismiss) var dismiss
    var appState = AppState.shared
    @StateObject private var viewModel = VeiculoViewModel()
    
    var body: some View
    {
        NavigationView
        {
            VStack(alignment: .leading)
            {
                ForEach(viewModel.veiculosLista, id: \.self) { veiculo in
                    ZStack
                    {
                        HStack
                        {
                            HStack
                            {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                                    .opacity(veiculo.ativo == true ? 100 : 0.0)
                                Text(String(veiculo.nome ?? ""))
                                Text(" "); Text(String(veiculo.placa ?? ""))
                                Text(" "); Text(String(veiculo.ano))
                            }
                        }// .onTapGesture() { marcarCarroComoAtivo(ativoID: carros.objectID)}
                        Spacer()
                    }
                }
            }
            .background(Color("backGroundColor"))
            .scrollContentBackground(.hidden)
            .navigationBarTitle("Selecione um veículo", displayMode: .inline )
            .toolbar(content: {
                ToolbarItem {
                    Button { dismiss()}
                label: { Label("Dismiss", systemImage: "xmark.circle.fill")}
                }
                
            }
            )
        }.presentationDetents([.medium])
    }
}
