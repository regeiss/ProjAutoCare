//
//  LoadingView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 08/09/23.
//

import SwiftUI

struct LoadingView: View
{
    let text: String
    
    var body: some View
    {
        VStack(spacing: 8)
        {
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(1.5)
            Text(text)
        }
    }
}
