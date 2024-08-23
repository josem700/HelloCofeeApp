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
    private var white = Color(red: 238/255, green: 247/255, blue: 255/255)
    private var cyan = Color(red: 205/255, green: 232/255, blue: 229/255)
    
    private func populateOrders() async{
        do{
            try await model.populateOrders()
        }
        catch{
            print(error)
        }
    }
    
    private func deleteOrder(_ indexSet: IndexSet) {
        indexSet.forEach { index in
            let order = model.orders[index]
            guard let orderId = order.id else {
                return
            }
            Task{
                do{
                    try await model.deleteOrder(orderId)
                }catch{
                    print(error)
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if model.orders.isEmpty {
                    Text("No orders available!").accessibilityIdentifier("noOrdersText")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }else{
                    List {
                        ForEach(model.orders){order in
                            NavigationLink(value: order.id) {
                                OrderCellView(order: order)
                            }
                        }.onDelete(perform: deleteOrder)
                            .listRowBackground(cyan)
                            .padding(10)
                    }.accessibilityIdentifier("orderList")
                        .listStyle(.automatic)
                        .scrollContentBackground(.hidden)
                        
                }
            }
            .background(white)
            .navigationDestination(for: Int.self, destination: {orderId in
                OrderDetailView(orderId: orderId)
            })
            .task {
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
        .background(white)
        }
    }
}

#Preview {
    var config = Configuration()
    return ContentView().environmentObject(CoffeeModel(webservice: WebService(baseURL: config.environment.baseURL)))
}
