//
//  HelloCofeeAppApp.swift
//  HelloCofeeApp
//
//  Created by Jose M on 20/8/24.
//

import SwiftUI

@main
struct HelloCofeeAppApp: App {
    @StateObject private var model: CoffeeModel
    
    init(){
        var config = Configuration()
        //Inicializamos el objeto CoffeeModel
        let webService = WebService(baseURL: config.environment.baseURL)
        _model = StateObject(wrappedValue: CoffeeModel(webservice: webService))
    }
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(model)
        }
    }
}
