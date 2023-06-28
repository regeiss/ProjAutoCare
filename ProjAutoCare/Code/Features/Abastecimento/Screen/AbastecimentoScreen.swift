//
//  AbastecimentoScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/06/23.
//

import SwiftUI
import CoreData
import FormValidator

enum AbastecimentoFocusable: Hashable
{
    case km
    case data
    case litros
    case valorLitro
    case completo
}

class AbastecimentoFormInfo: ObservableObject
{
    @Published var km: String = ""
    @Published var data: Date = Date()
    @Published var litros: String = ""
    @Published var valorLitro: String = ""
    @Published var completo: Bool = false
    
    let regexNumerico: String =  "[0-9[\\b]]+"
    
     @Published
    var manager = FormManager(validationType: .immediate)

    // 3
    @FormField(validator: NonEmptyValidator(message: "This field is required!"))
    var firstName: String = ""

    // 4
    lazy var firstNameValidation = _firstName.validation(manager: manager)
 
}

@available(iOS 16.0, *)
struct AbastecimentoScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var errorHandling: ErrorHandling
    var appState = AppState.shared
    
    @StateObject private var viewModel = AbastecimentoViewModel()
    @StateObject private var viewModelPosto = PostoViewModel()
    @StateObject private var viewModelVeiculo = VeiculoViewModel()
    
    @ObservedObject var formInfo = AbastecimentoFormInfo()
    @State var isSaveDisabled: Bool = true
    @FocusState private var abastecimentoInFocus: AbastecimentoFocusable?
    @State var posto: Posto?
    
    let pub = NotificationCenter.default.publisher(for: Notification.Name("Save"))
    
    private var valorTotal: String
    {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let total = (Double(formInfo.litros) ?? 0) * (Double(formInfo.valorLitro) ?? 0)
        
        return formatter.string(from: NSNumber(value: total)) ?? "$0"
    }
    
    var body: some View
    {
//        NavigationStack
//        {
            VStack
            {
                Form
                {
                    Section
                    {
                        TextField("km", text: $formInfo.km)
                            // .focused($abastecimentoInFocus, equals: .km)
                            // .keyboardType(.numbersAndPunctuation)
                            // .onAppear{ DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {self.abastecimentoInFocus = .km}}
                        DatePicker("data", selection: $formInfo.data)
                            .frame(maxHeight: 400)
                            .focused($abastecimentoInFocus, equals: .data)
                        TextField("litros", text: $formInfo.litros)
                            .focused($abastecimentoInFocus, equals: .litros)
                            .keyboardType(.numbersAndPunctuation)
                        TextField("valorLitro", text: $formInfo.valorLitro)
                            .focused($abastecimentoInFocus, equals: .litros)
                            .keyboardType(.numbersAndPunctuation)
                        Text("Valor total \(valorTotal)")
                        Toggle(isOn: $formInfo.completo)
                        {
                            Text("completo")
                        }.focused($abastecimentoInFocus, equals: .completo)
                        
                        Picker("Posto:", selection: $posto)
                        {
                            Text("Nenhum").tag(Posto?.none)
                            ForEach(viewModelPosto.postosLista) { (posto: Posto) in
                                Text(posto.nome!).tag(posto as Posto?)
                            }
                        }.pickerStyle(.automatic)
                    }
                }.scrollContentBackground(.hidden)
                // .onReceive(pub)  {_ in gravarAbastecimento()}
            }// .onReceive(formInfo.form.$allValid) { isValid in self.isSaveDisabled = !isValid}
            .background(Color("backGroundMain"))
            .navigationTitle("Abastecimento")
            .navigationBarTitleDisplayMode(.automatic)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading)
                { Button {
                    dismiss()
                }
                    label: { Text("Cancelar")}}
                ToolbarItem(placement: .navigationBarTrailing)
                { Button {
                    gravarAbastecimento()
                    dismiss()
                }
                    label: { Text("OK")}}
            }
       // }
    }
    
    private func saveAbastecimento() throws
    {
        var postoPicker: Posto?
        var veiculoAtual: Veiculo?
        
        if posto == nil
        {
            postoPicker = appState.postoPadrao
            
        }
        else
        {
            postoPicker = posto
        }

//        if appState.veiculoAtivo == nil
//        {
//            veiculoAtual = viewModelVeiculo.carrosLista.first
//        }
//        else
//        {
//            veiculoAtual = appState.carroAtivo
//        }

        let uab = AbastecimentoDTO(id: UUID(),
                                          km: (Int32(formInfo.km) ?? 0),
                                          data: formInfo.data,
                                          litros: (Double(formInfo.litros) ?? 0),
                                          valorLitro: (Double(formInfo.valorLitro) ?? 0),
                                          valorTotal: (Decimal((Double(formInfo.litros) ?? 0) * (Double(formInfo.valorLitro) ?? 0))),
                                          completo:  Bool(formInfo.completo),
                                          media: calculaMedia(kmAtual: Int32(formInfo.km) ?? 0, litros: Double(formInfo.litros) ?? 0)
//                                          doPosto: postoPicker!,
//                                          doCarro: veiculoAtual!)
        )
        
            viewModel.add(abastecimento: uab)
    }
    
    private func gravarAbastecimento()
    {
        let valid = true //  formInfo.form.triggerValidation()
        if valid
        {
            do
            {
                try saveAbastecimento()
            }

            catch
            {
                self.errorHandling.handle(error: error)
            }
        }
    }

    private func calculaMedia(kmAtual: Int32, litros: Double) -> Double
    {
        var media: Double
        var kmPercorrida: Int32
        
        if viewModel.abastecimentosLista.count == 0
        {
            return 0
        }
        else
        {
            kmPercorrida = kmAtual - appState.ultimaKM
            media = Double(kmPercorrida) / (Double(formInfo.litros) ?? 0)
            return media
        }
    }
}

