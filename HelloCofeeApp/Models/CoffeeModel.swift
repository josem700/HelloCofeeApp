//
//  CoffeeModel.swift
//  HelloCofeeApp
//
//  Created by Jose M on 20/8/24.
//

import Foundation

@MainActor
class CoffeeModel: ObservableObject {
    
    let webservice: WebService
    //(set) indica que solo se le puede dar valor desde dentro de la clase, no desde fuera
    @Published private(set) var orders: [Order] = []
    
    init(webservice: WebService){
        self.webservice = webservice
    }
    
    func populateOrders() async throws {
       orders = try await webservice.getOrders()
    }
    
    func placeOrder(_ order: Order) async throws{
        let newOrder = try await webservice.placeOrder(order: order)
        orders.append(newOrder)
    }
}
