//
//  NumberFormatter+Extensions.swift
//  HelloCofeeApp
//
//  Created by Jose M on 20/8/24.
//

import Foundation

extension NumberFormatter {
    static var currency: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
}
