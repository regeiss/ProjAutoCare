//
//  AbastecimentoListaDetalheView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/06/23.
//

import SwiftUI

struct AbastecimentoListaDetalheView: View
{
    var abastecimento: AbastecimentoModel
    
    var body: some View
    {
        Text(abastecimento.id.uuidString)
    }
}
