//
//  AppEnvironment.swift
//  HelloCofeeApp
//
//  Created by Jose M on 20/8/24.
//
// Este archivo contiene las variables de entorno usadas en la app

import Foundation
import SwiftUI

enum EndPoints {
    //EndPoints para las url
    case allOrders
    case placeOrder
    case deleteOrder(Int)
    case updateOrder(Int)
    
    var path: String {
        switch self {
            case .allOrders:
                return "/test/orders"
            
            case .placeOrder:
                return "/test/new-order"
            
            case .deleteOrder(let orderId):
                return "/test/orders/\(orderId)"
            
            case .updateOrder(let orderId):
                return "/test/orders/\(orderId)"
        }
    }
}

struct Configuration {
    //Lazy es para que solo se defina una vez
    lazy var environment: AppEnvironment = {
    // leer valor de environment
        guard let env = ProcessInfo.processInfo.environment["ENV"] else {
            return AppEnvironment.dev
        }
        if env == "TEST" {
            return AppEnvironment.test
        }
        
        return AppEnvironment.dev
    }()
}

enum AppEnvironment: String{
    //Url de test y de produccion
    case dev
    case test
    
    var baseURL: URL{
        switch self {
        case .dev:
            return URL(string: "https://island-bramble.glitch.me")!
        case .test:
            return URL(string: "https://island-bramble.glitch.me")!
        }
    }
}

struct Colors {
    let white = Color(red: 238/255, green: 247/255, blue: 255/255)
    let cyan = Color(red: 205/255, green: 232/255, blue: 229/255)
    let teal = Color(red: 122/255, green: 178/255, blue: 178/255)
    let blue = Color(red: 77/255, green: 134/255, blue: 156/255)
    let red = Color(red: 223/255, green: 130/255, blue: 108/255)
}
