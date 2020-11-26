//
//  Double+Extension.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 08/09/20.
//

import Foundation
import UIKit

extension Double {
    
    func idnCurrency(shouldRemovePrefix: Bool = false) -> String{
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.numberStyle = .currency
        let returnedValue = formatter.string(from: NSNumber(value: self))
        return returnedValue ?? ""
    }
    
    func convertIntoRupiah() -> String {
        let components = ["Rp", self.idnCurrency(shouldRemovePrefix: true).removeIDRFromCurrency()].joined(separator: " ")
        return components
    }
    
    
}

extension String {
    func removeIDRFromCurrency() -> String {
        let value = self.replacingOccurrences(of: "Rp", with: "").replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: ".")
        if String(describing: value.suffix(3)).isEqual(".00") {
            return String(describing: value.dropLast(3))
        }
        return value
    }
}
