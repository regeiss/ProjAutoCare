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
    // lazy var form = { FormValidation(validationType: .deferred)}()
    // lazy var valKMVazio: ValidationContainer = { $km.nonEmptyValidator(form: form, errorMessage: "km deve ser informada")}()
    // lazy var valKMNumerico: ValidationContainer = { $km.patternValidator(form: form, pattern: regexNumerico, errorMessage: "km deve ser númerica")}()
    // lazy var valLitros: ValidationContainer = { $litros.nonEmptyValidator(form: form, errorMessage: "qtd litros deve ser informada")}()
    // lazy var valLitrosNumerico: ValidationContainer = { $litros.patternValidator(form: form, pattern: regexNumerico, errorMessage: "qtd litros deve ser númerica")}()
    // lazy var valValorLitro: ValidationContainer = { $valorLitro.nonEmptyValidator(form: form, errorMessage: "valor deve ser informado")}()
    // lazy var valValorNumerico: ValidationContainer = { $valorLitro.patternValidator(form: form, pattern: regexNumerico, errorMessage: "valor litro deve ser númerico")}()
    // lazy var dataAbastecimento: ValidationContainer = { $data.dateValidator(form: form, before: Date(), errorMessage: "data não pode ser maior que hoje")}()
}

@available(iOS 16.0, *)
struct AbastecimentoScreen: View
{
    @EnvironmentObject var errorHandling: ErrorHandling
    var appState = AppState.shared
    
    @StateObject private var viewModel = AbastecimentoViewModel()
    @StateObject private var viewModelPosto = PostoViewModel()
    @StateObject private var viewModelCarro = CarroViewModel()
    
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
        NavigationView
        {
            VStack
            {
                Form
                {
                    Section()
                    {
                        TextField("km", text: $formInfo.km)
                            .validation(formInfo.valKMVazio)
                            .validation(formInfo.valKMNumerico)
                            .focused($abastecimentoInFocus, equals: .km)
                            .keyboardType(.numbersAndPunctuation)
                            .onAppear{ DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {self.abastecimentoInFocus = .km}}
                        DatePicker("data", selection: $formInfo.data)
                            .frame(maxHeight: 400)
                            .focused($abastecimentoInFocus, equals: .data)
                            .validation(formInfo.dataAbastecimento)
                        TextField("litros", text: $formInfo.litros)
                            .validation(formInfo.valLitros)
                            .validation(formInfo.valLitrosNumerico)
                            .focused($abastecimentoInFocus, equals: .litros)
                            .keyboardType(.numbersAndPunctuation)
                        TextField("valorLitro", text: $formInfo.valorLitro)
                            .validation(formInfo.valValorLitro)
                            .validation(formInfo.valValorNumerico)
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
                }
                .onReceive(pub)  {_ in gravarAbastecimento()}
            }.onReceive(formInfo.form.$allValid) { isValid in self.isSaveDisabled = !isValid}
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
    
    private func saveAbastecimento() throws
    {
        var postoPicker: Posto?
        var carroAtual: Veiculo?
        
        if posto == nil
        {
            postoPicker = appState.postoPadrao
            
        }
        else
        {
            postoPicker = posto
        }

        if appState.carroAtivo == nil
        {
            carroAtual = viewModelCarro.carrosLista.first
        }
        else
        {
            carroAtual = appState.carroAtivo
        }

        let uab = AbastecimentoModel(id: UUID(),
                                          km: (Int32(formInfo.km) ?? 0),
                                          data: formInfo.data,
                                          litros: (Double(formInfo.litros) ?? 0),
                                          valorLitro: (Double(formInfo.valorLitro) ?? 0),
                                          valorTotal: (Decimal((Double(formInfo.litros) ?? 0) * (Double(formInfo.valorLitro) ?? 0))),
                                          completo:  Bool(formInfo.completo),
                                          media: calculaMedia(kmAtual: Int32(formInfo.km) ?? 0, litros: Double(formInfo.litros) ?? 0),
                                          doPosto: postoPicker!,
                                          doCarro: carroAtual!)
        
            viewModel.add(abastecimento: uab)
    }
    
    private func gravarAbastecimento()
    {
        let valid = formInfo.form.triggerValidation()
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

