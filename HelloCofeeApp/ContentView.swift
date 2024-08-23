//
//  ContentView.swift
//  HelloCofeeApp
//
//  Created by Jose M on 20/8/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var model: CoffeeModel
    @State var isPresented = false
    
    private func populateOrders() async{
        do{
            try await model.populateOrders()
        }
        catch{
            print(error)
        }
    }
    
    var body: some View {
        NavigationStack {
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
            .sheet(isPresented: $isPresented, content: {
                AddCoffeeView()
            })
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button("Add New Order") {
                        isPresented = true
                    }.accessibilityIdentifier("addNewOrderButton")
                }
            }
        .padding()
        }
    }
}

#Preview {
    var config = Configuration()
    return ContentView().environmentObject(CoffeeModel(webservice: WebService(baseURL: config.environment.baseURL)))
}
