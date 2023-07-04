//
//  CadastroScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/06/23.
//

import SwiftUI

struct CadastroListaScreen: View 
{
    @State var categoria = false 
    @State var servico = false
    @State var veiculo = false
    @State var posto = false 

    var body: some View 
    {
        let cadastroMenu = [
            CadastroColecao(id: 0, name: "Categorias", image: "gasStation", menu: .categoria),
            CadastroColecao(id: 1, name: "Serviços", image: "service", menu: .servico),
            CadastroColecao(id: 2, name: "Veículos", image: "report", menu: .veiculo),
            CadastroColecao(id: 3, name: "Postos", image: "alertas", menu: .posto),
            CadastroColecao(id: 4, name: "Perfil", image: "config", menu: .perfil)
        ]
        VStack(alignment: .leading)
        {
            VStack
            {
                ForEach(cadastroMenu) { item in
                    NavigationLink(value: item) {
                        
                        CadastroDetalheView(colecao: item)
                    }
                }.padding([.leading, .trailing])
            }.navigationDestination(for: CadastroColecao.self) { item in
                switch item.menu {
                case .categoria:
                    CategoriaListaScreen()
                case .servico:
                    ServicoListaScreen()
                case .veiculo:
                    VeiculoListaScreen()
                case .posto:
                    PostoListaScreen()
                case .perfil:
                    PerfilListaScreen()
                }
            }.padding()
            Spacer()
        }.navigationTitle("Cadastros")
            .background(Color("backGroundColor"))
    }
}
