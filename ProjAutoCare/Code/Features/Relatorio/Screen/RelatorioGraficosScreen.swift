//
//  RelatorioGraficosScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 31/07/23.
//

import SwiftUI
import Charts

struct MountPrice: Identifiable {
    var id = UUID()
    var mount: String
    var value: Double
    var type: String
}

struct RelatorioGraficosScreen: View
{
    @State var filtroPeriodo: [String: String] = ["Periodo": ""]
    @State private var isShowingSheet = false
    
    let data: [MountPrice] = [
        MountPrice(mount: "jan/22", value: 5, type: "A"),
        MountPrice(mount: "feb/22", value: 4, type: "A"),
        MountPrice(mount: "mar/22", value: 7, type: "A"),
        MountPrice(mount: "apr/22", value: 15, type: "A"),
        MountPrice(mount: "may/22", value: 14, type: "A"),
        MountPrice(mount: "jun/22", value: 27, type: "A"),
        MountPrice(mount: "jul/22", value: 27, type: "A"),
        
        MountPrice(mount: "jan/22", value: 15, type: "B"),
        MountPrice(mount: "feb/22", value: 14, type: "B"),
        MountPrice(mount: "mar/22", value: 17, type: "B"),
        MountPrice(mount: "apr/22", value: 25, type: "B"),
        MountPrice(mount: "may/22", value: 24, type: "B"),
        MountPrice(mount: "jun/22", value: 37, type: "B"),
        MountPrice(mount: "jul/22", value: 49, type: "B")
    ]
    var body: some View
    {
        VStack
        {
            List {
                Chart {
                    ForEach(data) {
                        AreaMark(
                            x: .value("Mount", $0.mount),
                            y: .value("Value", $0.value)
                        )
                        .foregroundStyle(by: .value("Type", "Series \($0.type)"))
                    }
                }
                .frame(height: 250)
            }.scrollContentBackground(.hidden)
        }
        .background(Color("backGroundColor"))
        .navigationTitle("Gráficos")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .primaryAction)
            {
                Button(action: {
                }) {
                    Image(systemName: "plus")
                }
            }
        } .toolbarTitleMenu { // ADD THIS!
            Button("Save") {
                print("save document")
            }.buttonStyle(.borderedProminent)
            
            Button("Delete") {
                print("delete document")
            }.buttonStyle(.borderedProminent)

            Image(systemName: "bus")
        }
    }
}
