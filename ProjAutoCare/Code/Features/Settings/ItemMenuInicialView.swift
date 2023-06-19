//
//  ItemMenuView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 18/06/23.
//

import SwiftUI

struct ItemMenuInicialView: View
{
    var collection: Collections
    let height: CGFloat = 110
    var body: some View
    {
        ZStack(alignment: .bottomTrailing)
        {
            // TODO: Verificar o tamanho da imagem e do retangulo
            //            Image(collection.image)
            //            .resizable()
            //            .aspectRatio(contentMode: .fill)
            //                .frame(height: collection.name == "Abastecimento" ? 150 : height)
            //                .cornerRadius(20)
            //                .clipped()
            //                .overlay(
            //                    Rectangle()
            //                        .foregroundColor(.black)
            //                        .cornerRadius(20)
            //                        .opacity(0.2)
            //                        .frame(height: height)
            //                        .onTapGesture { screenRouter(indice: collection.id)}
            //                    )
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray)
                .frame(height: collection.name == "Abastecimento" ? 150 : height)
                .opacity(0.4)
                //.onTapGesture { screenRouter(indice: collection.id)}
            
            Text(collection.name)
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.heavy)
                .foregroundColor(.orange)
                .offset(x: 1.0, y: 10)
                .padding()
                //.onTapGesture { screenRouter(indice: collection.id)}
            
            //                if collection.name == "Abastecimento"
            //                {
            //                    UltimoAbastecimentoView().offset(x: -10, y: -50)
            //                }
        }.frame(minWidth: 230, maxWidth: .infinity, minHeight: height, maxHeight: 150)
    }
}
