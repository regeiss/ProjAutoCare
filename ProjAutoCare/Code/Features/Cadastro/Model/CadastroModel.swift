//
//  CadastroModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 29/06/23.
//

import Foundation

enum Cadastro: String
{
    case categoria
    case servico
    case veiculo
    case posto
    case diversos
}

struct CadastroColecao: Identifiable, Hashable
{
    var id: Int
    var name: String
    var image: String
    var menu: Cadastro
}
