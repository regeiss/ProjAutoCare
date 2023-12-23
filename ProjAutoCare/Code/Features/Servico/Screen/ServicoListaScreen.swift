//
//  ServicoListaScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 02/07/23.
//

import SwiftUI
import SwiftUICoordinator

struct ServicoListaScreen<Coordinator: Routing>: View
{
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewModel = ViewModel<Coordinator>()
    
    @StateObject var viewModelServico = ServicoViewModel()
    @State private var adicao = false
    
    var body: some View
    {
        VStack
        {
            List
            {
                ForEach(viewModelServico.servicoLista) { servico in
                    HStack
                    {
                        ServicoListaDetalheView(viewModel: viewModelServico, servico: servico)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("Excluir", systemImage: "trash", role: .destructive, action: { viewModelServico.delete(servico: servico)})
                    }
                }
                
                if viewModelServico.servicoLista.isEmpty
                {
                    Text("").listRowBackground(Color.clear)
                }
            }
        }
        .background(Color("backGroundColor"))
        .scrollContentBackground(.hidden)
        .toolbar { ToolbarItem(placement: .navigationBarTrailing)
            { Button {
                adicao = true
            }
                label: { Image(systemName: "plus")}}
        }
    }
}

extension ServicoListaScreen
{
    @MainActor class ViewModel<R: Routing>: ObservableObject
    {
        
        var coordinator: R?

        func didTapBuiltIn() {
            //  coordinator?.handle(ShapesAction.simpleShapes)
        }

        func didTapCustom() {
           // coordinator?.handle(ShapesAction.customShapes)
        }

        func didTapFeatured() {
//            let routes: [NavigationRoute] = [
//                SimpleShapesRoute.circle,
//                CustomShapesRoute.tower,
//                SimpleShapesRoute.capsule
//            ]
//
//            guard let route = routes.randomElement() else {
//                return
//            }

            // coordinator?.handle(ShapesAction.featuredShape(route))
        }
    }
}
