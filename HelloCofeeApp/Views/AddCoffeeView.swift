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
    var order: Order? = nil
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
    
    private func placeOrder(_ order: Order) async{
        do {
            try await model.placeOrder(order)
            //dismiss
            dismiss()
        } catch {
            print(error)
        }
    }
    
    private func populateExistingOrder() {
        if let order = order {
            name = order.name
            coffeeName = order.coffeeName
            price = String(order.total)
            coffeeSize = order.size
        }
    }
    
    private func updateOrder(_ order: Order) async {
        do{
            try await model.updateOrder(order)
        }catch{
            print(error)
        }
    }
    
    private func saveOrUpdate() async {
        if let order {
            var editOrder = order
            editOrder.name = name
            editOrder.total = Double(price) ?? 0.0
            editOrder.coffeeName = coffeeName
            editOrder.size = coffeeSize
            await updateOrder(editOrder)
        } else {
            let order = Order(name: name, coffeeName: coffeeName, total: Double(price) ?? 0, size: coffeeSize)
            await placeOrder(order)
        }
        
        dismiss()
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
                    
                
                Button() {
                    if isValid {
                        //Realizar orden
                        Task{
                            await saveOrUpdate()
                        }
                    }
                } label: {
                    HStack{
                        Text(order != nil ? "Update Order" : "Place Order")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundStyle(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Colors().teal)
                .clipShape(.rect(cornerRadius: 10))
                .padding(.top, 10)
                .accessibilityIdentifier("placeOrderButton")
                    .centerHorizontally()
            }
            .scrollContentBackground(.hidden)
            .navigationTitle(order != nil ? "Update Coffee" : "Add Cofee")
            .onAppear() {
                populateExistingOrder()
            }
        }
    }
}

#Preview {
    AddCoffeeView()
}
