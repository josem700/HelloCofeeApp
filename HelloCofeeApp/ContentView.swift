//
//  ContentView.swift
//  HelloCofeeApp
//
//  Created by Jose M on 20/8/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var model: CoffeeModel
    
    private func populateOrders() async{
        do{
            try await model.populateOrders()
        }
        catch{
            print(error)
        }
    }
    
    var body: some View {
        VStack {
            if model.orders.isEmpty {
                Text("No orders available!").accessibilityIdentifier("noOrdersText")
            }else{
                List(model.orders){order in
                    OrderCellView(order: order)
                }
            }
        }.task {
            await populateOrders()
        }
        .padding()
    }
}

#Preview {
    var config = Configuration()
    return ContentView().environmentObject(CoffeeModel(webservice: WebService(baseURL: config.environment.baseURL)))
}
