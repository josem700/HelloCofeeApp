//
//  WebService.swift
//  HelloCofeeApp
//
//  Created by Jose M on 20/8/24.
//

import Foundation

enum NetworkError: Error{
    case badRequest
    case decodingError
    case badUrl
}

class WebService {
    private var baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func updateOrder(_ order: Order) async throws -> Order {
        guard let orderId = order.id else {
            throw NetworkError.badRequest
        }
        
        guard let url = URL(string: EndPoints.updateOrder(orderId).path, relativeTo: baseURL) else{
            throw NetworkError.badUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(order)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let updatedOrder = try? JSONDecoder().decode(Order.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return updatedOrder
    }
    
    func deleteOrder(orderId: Int) async throws -> Order {
        guard let url = URL(string: EndPoints.deleteOrder(orderId).path, relativeTo: baseURL) else{
            throw NetworkError.badUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let deletedOrder = try? JSONDecoder().decode(Order.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return deletedOrder
    }
    
    func getOrders() async throws -> [Order] {
        //Obtener todas las ordenes
        guard let url = URL(string: EndPoints.allOrders.path, relativeTo: baseURL) else{
            throw NetworkError.badUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let orders = try? JSONDecoder().decode([Order].self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return orders
    }
    
    func placeOrder(order: Order) async throws -> Order {
        //Crear Ordenes
        guard let url = URL(string: EndPoints.placeOrder.path, relativeTo: baseURL) else{
            throw NetworkError.badUrl
        }
        
        var request = URLRequest(url: url)
        //Modo de la peticion
        request.httpMethod = "POST"
        //Tipo de dato
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //Cuerpo de la peticion que estamos enviando
        request.httpBody = try JSONEncoder().encode(order)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        //Obtenemos la orden creada
        guard let newOrder = try? JSONDecoder().decode(Order.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return newOrder
    }
}
