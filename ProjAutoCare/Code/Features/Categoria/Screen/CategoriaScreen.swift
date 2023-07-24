//
//  CategoriaScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 09/07/23.
//

import SwiftUI
import CoreData
import FormValidator

enum CategoriaFocusable: Hashable
{
    case nome
}

class CategoriaFormInfo: ObservableObject
{
    @Published var manager = FormManager(validationType: .deferred)
    @FormField(validator: NonEmptyValidator(message: "Preencha este campo!"))
    var nome: String = ""
    lazy var nomeVazio = _nome.validation(manager: manager)
}

//@available(iOS 16.0, *)
//struct CategoriaScreen: View
//{
//    @Environment(\.dismiss) private var dismiss
//    @ObservedObject var viewModel: CategoriaViewModel
//    @ObservedObject var formInfo = CategoriaFormInfo()
//    @FocusState private var categoriaInFocus: CategoriaFocusable?
//    @State var isSaveDisabled: Bool = true
//    
//    var categoria: Categoria
//    var isEdit: Bool
//    var isRead: Bool
//    var isAdd: Bool 
//    
//    var body: some View
//    {
//        VStack
//        {
//            Form
//            {
//                Section
//                {
//                    TextField("nome", text: $formInfo.nome)
//                        .autocorrectionDisabled(true)
//                        .validation(formInfo.nomeVazio)
//                        .focused($categoriaInFocus, equals: .nome)
//                        .onAppear{ DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {self.categoriaInFocus = .nome}}
//                }
//            }
//            .scrollContentBackground(.hidden)
//            .onReceive(formInfo.manager.$allValid) { isValid in
//                self.isSaveDisabled = !isValid}
//        }.onAppear
//        {
//            if isEdit
//            {
//                formInfo.nome = categoria.nome ?? ""
//            }
//        }
//        .background(Color("backGroundColor"))
//        .navigationTitle("Categoria")
//        .navigationBarTitleDisplayMode(.automatic)
//        .navigationBarBackButtonHidden()
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading)
//            { Button {
//                dismiss()
//            }
//                label: { Text("Cancelar")}}
//            ToolbarItem(placement: .navigationBarTrailing)
//            { Button {
//                
//                dismiss()
//            }
//            label: { Text("OK").disabled(isSaveDisabled)}
//            }
//        }
//    }
//}
