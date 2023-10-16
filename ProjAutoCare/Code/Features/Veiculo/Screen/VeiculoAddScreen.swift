//
//  VeiculoAddScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 24/07/23.
//

import SwiftUI
import FormValidator

struct VeiculoAddScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: VeiculoViewModel
    @ObservedObject var formInfo = VeiculoFormInfo()
    @StateObject private var viewModelMarca = MarcaViewModel()
    @StateObject private var viewModelModelo = ModeloViewModel()
    @FocusState private var veiculoInFocus: VeiculoFocusable?
    @State var isSaveDisabled: Bool = true
    
    @State var marca: Marca?
    @State var modelo: Modelo?
    
    var body: some View
    {
        VStack
        {
            Form
            {
                Section
                {
                    TextField("nome", text: $formInfo.nome)
                        .validation(formInfo.nomeVazio)
                        .focused($veiculoInFocus, equals: .nome)
                        .onAppear{ DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {self.veiculoInFocus = .nome}}
                    
                    Picker("Marca:", selection: $marca)
                    {
                        Text("Nenhuma").tag(Marca?.none)
                        ForEach(viewModelMarca.marcaLista) { (marca: Marca) in
                            Text(marca.nome!).tag(marca as Marca?)
                        }
                    }
                    .pickerStyle(.automatic)
                     
                    Picker("Modelo:", selection: $modelo)
                    {
                        let filteredArray = viewModelModelo.modeloLista.filter { $0.idmarca == marca?.id }
                        Text("Nenhuma").tag(Modelo?.none)
                        ForEach(filteredArray) { (modelo: Modelo) in
                            Text(modelo.nome!).tag(modelo as Modelo?)
                        }
                    }.pickerStyle(.automatic)

                    TextField("placa", text: $formInfo.placa)
                    TextField("chassis", text: $formInfo.chassis)
                    TextField("ano", text: $formInfo.ano)
                }
            }
            .scrollContentBackground(.hidden)
            .onReceive(formInfo.manager.$allValid) { isValid in
                self.isSaveDisabled = !isValid}
            .background(Color("backGroundColor"))
            .navigationTitle("Veículos")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading)
                { Button {
                    dismiss()
                }
                    label: { Text("Cancelar")}}
                ToolbarItem(placement: .navigationBarTrailing)
                { Button {
                    save()
                    dismiss()
                }
                label: { Text("OK").disabled(isSaveDisabled)}
                }
            }
        }
    }
    
    func save()
    {
        let valid = formInfo.manager.triggerValidation()
        if valid
        {
            let veiculo = VeiculoDTO(id: UUID(),
                                     nome: formInfo.nome,
                                     veiculoModelo: modelo!,
                                     placa: formInfo.placa,
                                     chassis: formInfo.chassis,
                                     ativo: false,
                                     padrao: false,
                                     ano: Int16(formInfo.ano) ?? 0)
            viewModel.add(veiculo: veiculo)
        }
    }
}
