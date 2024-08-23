//
//  AddCoffeeView.swift
//  HelloCofeeApp
//
//  Created by Jose M on 20/8/24.
//

import SwiftUI

struct AddCoffeeErrors {
    var name: String = ""
    var coffeeName: String = ""
    var price: String = ""
}

struct AddCoffeeView: View {
    @State private var name: String = ""
    @State private var coffeeName: String = ""
    @State private var price: String = ""
    @State private var coffeeSize: CoffeeSize = .medium
    @State private var errors: AddCoffeeErrors = AddCoffeeErrors()
    
    @EnvironmentObject private var model: CoffeeModel
    @Environment(\.dismiss) private var dismiss
    
    var isValid: Bool {
        errors = AddCoffeeErrors()
        if name.isEmpty {
            errors.name = "Name cannot be empty"
        }
        
        if coffeeName.isEmpty {
            errors.coffeeName = "Coffee name cannot be empty"
        }
        
        if price.isEmpty {
            errors.price = "Price cannot be empty"
        } else if(!price.isNumeric) {
            errors.price = "Price needs to be a number"
        }else if price.isLessThan(1) {
            errors.price = "Price needs to be more than 0"
        }
        
        return errors.name.isEmpty && errors.price.isEmpty && errors.coffeeName.isEmpty
    }
    
    private func placeOrder() async{
        let order = Order(name: name, coffeeName: coffeeName, total: Double(price) ?? 0, size: coffeeSize)
        do {
            try await model.placeOrder(order)
            //dismiss
            dismiss()
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .accessibilityIdentifier("name")
                Text(errors.name).visible(!errors.name.isEmpty)
                    .font(.caption)
                TextField("Coffee Name", text: $coffeeName)
                    .accessibilityIdentifier("coffeeName")
                Text(errors.coffeeName).visible(!errors.coffeeName.isEmpty)
                    .font(.caption)
                TextField("Price", text: $price)
                    .accessibilityIdentifier("price")
                Text(errors.price).visible(!errors.price.isEmpty)
                    .font(.caption)
                Picker("Select size", selection: $coffeeSize){
                    ForEach(CoffeeSize.allCases, id: \.rawValue) {size in
                        Text(size.rawValue).tag(size)
                    }
                }.pickerStyle(.segmented)
                
                Button("Place Order") {
                    if isValid {
                        //Realizar orden
                        Task{
                            await placeOrder()
                        }
                    }
                }.accessibilityIdentifier("placeOrderButton")
                    .centerHorizontally()
            }.navigationTitle("Add Cofee")
        }
    }
}

#Preview {
    AddCoffeeView()
}
