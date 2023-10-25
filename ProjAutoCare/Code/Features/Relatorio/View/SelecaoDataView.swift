//
//  SelecaoDataView.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 04/08/23.
//

import SwiftUI

struct SelecaoDataView: View
{
    @Environment(\.dismiss) var dismiss
    @Environment(\.calendar) var calendar
    @Binding var isShowingSheet: Bool
    @State var dates: Set<DateComponents> = []
    
    var body: some View
    {
        VStack
        {
            MultiDatePicker("Selecione as datas", selection: $dates)
                .environment(\.locale, Locale.init(identifier: "pt_BR"))
            Text(summary)
            Button("OK", action: { isShowingSheet.toggle() }).buttonStyle(.bordered)
            Spacer()
        }
        .presentationDetents([.medium, .large])
        .padding()
    }
    
    var summary: String
    {
        dates.compactMap { components in
            calendar.date(from: components)?.formatted(date: .long, time: .omitted)
        }.formatted()
    }
    
    func didDismiss()
    {
        print(summary)
    }
}
