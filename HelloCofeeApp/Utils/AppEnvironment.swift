//
//  AppEnvironment.swift
//  HelloCofeeApp
//
//  Created by Jose M on 20/8/24.
//
// Este archivo contiene las variables de entorno usadas en la app

import Foundation

enum EndPoints {
    //EndPoints para las url
    case allOrders
    case placeOrder
    
    var path: String {
        switch self {
        case .allOrders:
            return "/test/orders"
        case .placeOrder:
            return "/test/new-order"
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
