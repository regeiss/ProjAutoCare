//
//  DateExtensions.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 28/06/23.
//

import Foundation

extension Date
{
    var startOfDay: Date
    {
        return Calendar.current.startOfDay(for: self)
    }

    var startOfMonth: Date
    {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)

        return  calendar.date(from: components)!
    }

    var endOfDay: Date
    {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var endOfMonth: Date
    {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }

    func isMonday() -> Bool
    {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }
}

extension Date
{
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents
    {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int
    {
        return calendar.component(component, from: self)
    }
}
