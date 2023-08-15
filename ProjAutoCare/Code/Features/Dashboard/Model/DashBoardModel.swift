//
//  DashBoardModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 14/08/23.
//

import SwiftUI

struct StyledGauge: View
{
    @State var current: Double
    @State private var minValue = 0.0
    @State private var maxValue = 170.0
    let gradient = Gradient(colors: [.green, .yellow, .red])
    
    var body: some View {
        Gauge(value: current, in: minValue...maxValue) {
            Image(systemName: "heart.fill")
                .foregroundColor(.red)
        } currentValueLabel: {
            Text(String(format: "%.2f", current))
                .foregroundColor(Color.green)
        } minimumValueLabel: {
            Text("\(Int(minValue))")
                .foregroundColor(Color.green)
        } maximumValueLabel: {
            Text("\(Int(maxValue))")
                .foregroundColor(Color.red)
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(gradient)
    }
}
