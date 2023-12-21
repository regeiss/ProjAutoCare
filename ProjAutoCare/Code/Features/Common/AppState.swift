//
//  AppState.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 26/06/23.
//

import Foundation

class AppState
{
    var regexNumerico: NSRegularExpression
    var ultimaKM: Int32
    var veiculoAtivo: Veiculo?
    var perfilAtivo: Perfil?
    var postoPadrao: Posto?
    var abastecimentoItemLista: Abastecimento?
    
    static var shared = AppState()
    
    private init()
    {
        regexNumerico = try! NSRegularExpression(pattern: "[0-9[\\b]]+")
        ultimaKM = 1
    }
}
