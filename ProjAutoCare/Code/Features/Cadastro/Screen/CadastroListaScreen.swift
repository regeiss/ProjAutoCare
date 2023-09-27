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
            CadastroColecao(id: 1, name: "Marcas", image: "config", menu: .marca),
            CadastroColecao(id: 2, name: "Perfil", image: "perfil", menu: .perfil),
            CadastroColecao(id: 3, name: "Postos", image: "alertas", menu: .posto),
            CadastroColecao(id: 4, name: "Serviços", image: "service", menu: .servico),
            CadastroColecao(id: 5, name: "Serviço efetuado", image: "config", menu: .servicoEfetuado),
            CadastroColecao(id: 6, name: "Veículos", image: "report", menu: .veiculo),
            CadastroColecao(id: 7, name: "Modelos", image: "report", menu: .modelo)
        ]
        
        let columns = [ GridItem(.flexible(minimum: 230, maximum: .infinity))]
        
        VStack(alignment: .leading)
        {
            ScrollView(.vertical)
            {
                LazyVGrid(columns: columns, alignment: .center, spacing: 5)
                {
                    ForEach(cadastroMenu) { item in
                        NavigationLink(value: item) {
                            CadastroDetalheView(colecao: item)
                        }
                    }.padding([.leading, .trailing])
                }.navigationDestination(for: CadastroColecao.self) { item in
                    switch item.menu 
                    {
                    case .categoria:
                        CategoriaListaScreen()
                    case .servico:
                        ServicoListaScreen()
                    case .marca:
                        MarcaListaScreen()
                    case .servicoEfetuado:
                        ServicoEfetuadoListaScreen()
                    case .veiculo:
                        VeiculoListaScreen()
                    case .posto:
                        PostoListaScreen()
                    case .perfil:
                        PerfilListaScreen()
                    case .modelo:
                        ModeloListaScreen()
                    }
                }.padding()
            }.navigationTitle("Cadastros")
            .navigationBarTitleDisplayMode(.large)
            .background(Color("backGroundColor"))
        }
    }
}
