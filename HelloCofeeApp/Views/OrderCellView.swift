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
                    .font(.title)
                
                Text("\(order.coffeeName) (\(order.size.rawValue))")
                    .accessibilityIdentifier("coffeeNameAndSizeText")
                    .opacity(0.5)
            }
                Spacer()
                Text(order.total as NSNumber, formatter: NumberFormatter.currency)
                    .accessibilityIdentifier("coffeePriceText")
                    .font(.title3)
                    .bold()
                    .opacity(0.5)
        }
    }
}

#Preview {
    OrderCellView(order: Order(id: 0, name: "Juan", coffeeName: "Capucchino", total: 2.20, size: CoffeeSize.large))
}
