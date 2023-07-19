//
//  StringExtensions.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 12/06/23.
//

import Foundation

extension String
{
    func toCurrencyFormat() -> String
    {
        if let doubleValue = Double(self)
        {
            let numberFormatter = NumberFormatter()
            numberFormatter.locale = Locale(identifier: "pt_BR")
            numberFormatter.numberStyle = NumberFormatter.Style.currency
            return numberFormatter.string(from: NSNumber(value: doubleValue)) ?? ""
        }
        return ""
    }
    
    func toQuilometrosFormat() -> String
    {
        if let int32Value = Int32(self)
        {
            let numberFormatter = NumberFormatter()
            numberFormatter.locale = Locale(identifier: "pt_BR")
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            numberFormatter.currencyGroupingSeparator = "."
            numberFormatter.groupingSize = 3
            return numberFormatter.string(from: NSNumber(value: int32Value)) ?? ""
        }
        return ""
    }
    
    func toShortDateFormat(date: Date) -> String?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        guard let date = dateFormatter.date(from: self)
        else {return nil}
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
    }
}

extension String 
{
    var isNumber: Bool 
    {
        return self.range(
            of: "^[0-9]*$", // 1
            options: .regularExpression) != nil
    }
}