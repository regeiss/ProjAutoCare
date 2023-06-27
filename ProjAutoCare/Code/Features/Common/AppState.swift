//
//  AppState.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 26/06/23.
//

import Foundation

class AppState
{
    var ultimaKM: Int32
    var veiculoAtivo: Veiculo?
 //   var perfilAtivo: Perfil?
    var postoPadrao: Posto?
    
    static var shared = AppState()
    
    private init()
    {
        ultimaKM = 1
    }
}
