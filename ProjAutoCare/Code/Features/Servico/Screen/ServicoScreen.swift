//
//  ServicoScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 02/07/23.
//

import SwiftUI
import CoreData
import FormValidator

enum ServicoFocusable: Hashable
{
    case nome
}

class ServicoFormInfo: ObservableObject
{
    @Published var manager = FormManager(validationType: .deferred)
    @FormField(validator: NonEmptyValidator(message: "Preencha este campo!"))
    var nome: String = ""
    lazy var nomeVazio = _nome.validation(manager: manager)
    
    //        @FormField(validator: NonEmptyValidator(message: "Preencha este campo!"))
    //        var bandeira: String = ""
    //        lazy var bandeiraVazio = _bandeira.validation(manager: manager)
}

@available(iOS 16.0, *)
struct ServicoScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ServicoViewModel
    @ObservedObject var formInfo = ServicoFormInfo()
    @FocusState private var servicoInFocus: ServicoFocusable?
    @State var isSaveDisabled: Bool = true
    
    var servico: Servico
    var isEdit: Bool
    
    var body: some View
    {
        VStack
        {
            Form
            {
                Section
                {
                    TextField("nome", text: $formInfo.nome)
                        .autocorrectionDisabled(true)
                        .validation(formInfo.nomeVazio)
                        .focused($servicoInFocus, equals: .nome)
                        .onAppear{ DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {self.servicoInFocus = .nome}}
                }
            }
            .scrollContentBackground(.hidden)
            .onReceive(formInfo.manager.$allValid) { isValid in
                self.isSaveDisabled = !isValid}
        }.onAppear
        {
            if isEdit
            {
                formInfo.nome = servico.nome ?? ""
//                formInfo.bandeira = servico.bandeira ?? ""
            }
        }
        .background(Color("backGroundColor"))
        .navigationTitle("Serviço")
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
                save()
                dismiss()
            }
            label: { Text("OK").disabled(isSaveDisabled)}
            }
        }
    }
    
    func save()
    {
        let valid = formInfo.manager.triggerValidation()
        if valid
        {
            if isEdit
            {
                servico.nome = formInfo.nome
                // servico.bandeira = formInfo.bandeira
                viewModel.update(servico: servico)
            }
            else
            {
                let servicoNovo = ServicoDTO(id: UUID(), nome: formInfo.nome)
                viewModel.add(servico: servicoNovo)
            }
        }
    }
}
