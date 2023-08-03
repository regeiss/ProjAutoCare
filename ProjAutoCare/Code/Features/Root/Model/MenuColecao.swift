//
//  Collections.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 18/06/23.
//

import Foundation

enum MenuGeral: String
{
    case abastecimento
    case servico
    case relatorio
    case alerta
    case cadastro
}

struct MenuColecao: Identifiable, Hashable
{
    var id: Int
    var name: String
    var image: String
    var menu: MenuGeral
}
