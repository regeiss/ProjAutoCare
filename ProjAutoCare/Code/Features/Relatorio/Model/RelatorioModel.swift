//
//  RelatorioModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 10/07/23.
//

import Foundation

enum Relatorio: String
{
    case categoria
    case servico
    case veiculo
    case posto
    case perfil
}

struct RelatorioColecao: Identifiable, Hashable
{
    var id: Int
    var name: String
    var image: String
    var menu: Relatorio
}
