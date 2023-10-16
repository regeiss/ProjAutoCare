//
//  VeiculoEditScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 24/07/23.
//

import SwiftUI

struct VeiculoEditScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: VeiculoViewModel
    @StateObject var formInfo = VeiculoFormInfo()
    @StateObject private var viewModelMarca = MarcaViewModel()
    @StateObject private var viewModelModelo = ModeloViewModel()
    @FocusState private var veiculoInFocus: VeiculoFocusable?
    @State var isSaveDisabled: Bool = true
    @State var lista = false
    @State var marca: Marca?
    @State var modelo: Modelo?
    var veiculo: Veiculo
    
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
                    }.pickerStyle(.automatic)
                    .onAppear {
                        marca = veiculo.veiculoModelo?.eFabricado
                    }
                    
                    Picker("Modelo:", selection: $modelo)
                    {
                        let filteredArray = viewModelModelo.modeloLista.filter { $0.idmarca == marca?.id }
                        Text("Nenhuma").tag(Modelo?.none)
                        ForEach(filteredArray) { (modelo: Modelo) in
                            Text(modelo.nome!).tag(modelo as Modelo?)
                        }
                    }.pickerStyle(.automatic)
                    .onAppear {
                        modelo = veiculo.veiculoModelo
                    }
                    
                    TextField("placa", text: $formInfo.placa)
                    TextField("chassis", text: $formInfo.chassis)
                    TextField("ano", text: $formInfo.ano)
                }
            }
            .scrollContentBackground(.hidden)
            .onReceive(formInfo.manager.$allValid) { isValid in
                self.isSaveDisabled = !isValid}
            .onAppear
            {
                formInfo.nome = veiculo.nome ?? ""
                formInfo.placa = veiculo.placa ?? ""
                formInfo.chassis = veiculo.chassis ?? ""
                formInfo.ano = String(veiculo.ano)
            }
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
                    lista = true 
                }
                label: { Text("OK").disabled(isSaveDisabled)}
                }
            }
        }
        .navigationDestination(isPresented: $lista, destination: {
            VeiculoListaScreen()
        })
    }
    
    func save()
    {
        let valid = formInfo.manager.triggerValidation()
        if valid
        {
                veiculo.nome = formInfo.nome
                veiculo.veiculoModelo = modelo!
                veiculo.placa = formInfo.placa
                veiculo.chassis = formInfo.chassis
                veiculo.ano = Int16(formInfo.ano) ?? 1990
                viewModel.update(veiculo: veiculo)
        }
    }
}
