//
//  OrderCellView.swift
//  HelloCofeeApp
//
//  Created by Jose M on 20/8/24.
//

import SwiftUI

struct OrderCellView: View {
    let order: Order
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(order.name)
                    .accessibilityIdentifier("orderNameText")
                    .bold()
                
                Text("\(order.coffeeName) (\(order.size.rawValue))")
                    .accessibilityIdentifier("coffeeNameAndSizeText")
                    .opacity(0.5)
            }
                Spacer()
                Text(order.total as NSNumber, formatter: NumberFormatter.currency)
                    .accessibilityIdentifier("coffeePriceText")
        }
    }
}
