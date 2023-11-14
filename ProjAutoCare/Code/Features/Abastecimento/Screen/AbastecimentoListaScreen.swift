//
//  AbastecimentoListaScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/06/23.
//

import SwiftUI
import SwiftUICoordinator

@available(iOS 16.0, *)
struct AbastecimentoListaScreen<Coordinator: Routing>: View
{
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewRouteModel = ViewModel<Coordinator>()
    
    @StateObject var viewModel = AbastecimentoViewModel()
    @State private var adicao = false
    
    var body: some View
    {
        VStack
        {
            List
            {
                ForEach(viewModel.abastecimentosLista) { abastecimento in
                    HStack
                    {
                        AbastecimentoListaDetalheView(abastecimento: abastecimento)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("Exluir", systemImage: "trash", role: .destructive, action: { viewModel.delete(abastecimento: abastecimento)})
                    }
                }
                
                if $viewModel.abastecimentosLista.isEmpty
                {
                    Text("").listRowBackground(Color.clear)
                }
            }
        }.background(Color("backGroundColor"))
        .scrollContentBackground(.hidden)
        .navigationBarTitle("Abastecimento", displayMode: .automatic)
        .toolbar { ToolbarItem(placement: .navigationBarTrailing)
            { Button {
                adicao = true
            }
                label: { Image(systemName: "plus")}}
        }
        .navigationDestination(isPresented: $adicao, destination: {
            AbastecimentoAddScreen(isEdit: false)
        })
    }
}

extension AbastecimentoListaScreen
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
