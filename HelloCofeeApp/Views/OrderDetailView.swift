//
//  OrderDetailView.swift
//  HelloCofeeApp
//
//  Created by Jose M on 23/8/24.
//

import SwiftUI

struct OrderDetailView: View {
    
    let orderId: Int
    @EnvironmentObject private var model: CoffeeModel
    @State private var isPresented: Bool = false
    @Environment(\.dismiss) private var dismiss
    @State private var showingAlert = false
    
    private func deleteOrder() async {
        do{
            try await model.deleteOrder(orderId)
        }catch {
            print(error)
        }
        dismiss()
    }
    
    var body: some View {
        VStack{
            if let order = model.orderById(orderId) {
                VStack(alignment: .leading, spacing: 10){
                    Text (order.coffeeName)
                        .font(.title)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        .accessibilityIdentifier("coffeeNameText")
                        .bold()
                    
                   // Image
                    
                    Text(order.size.rawValue)
                        .opacity(0.5)
                        .fontWeight(.semibold)
                    
                    Text(order.total as NSNumber, formatter: NumberFormatter.currency)
                        .font(.title2)
                    
                    //HStack (spacing: 20){
                        
                        Button(){
                            showingAlert = true
                        }
                        label: {
                            HStack{
                                Text("Delete Order")
                                    .fontWeight(.semibold)
                                Image(systemName: "xmark.square")
                            }
                            .foregroundStyle(.white)
                            .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                        }
                        .alert("Do you want to delete this order?", isPresented: $showingAlert){
                            Button("Yes, I'm sure", role: .destructive) {
                                Task{
                                    await deleteOrder()
                                }
                            }
                            Button("No, take a step back", role: .cancel){
                                showingAlert=false
                            }
                        }
                        .background(Colors().red)
                        .clipShape(.rect(cornerRadius: 10))
                        .padding(.top, 10)
                        
                        
                        Button() {
                            //Editar Orden
                            isPresented = true
                        } label: {
                            HStack{
                                Text("Edit Order")
                                    .fontWeight(.semibold)
                                Image(systemName: "arrow.right")
                            }
                            .foregroundStyle(.white)
                            .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                        }
                        .accessibilityIdentifier("editOrderButton")
                        .background(Colors().teal)
                        .clipShape(.rect(cornerRadius: 10))
                        .padding(.top, 10)
                        Spacer()
                   // }
                }.sheet(isPresented: $isPresented){
                    AddCoffeeView(order: order)
                }
            }//If let order
            Spacer()
        }.padding()
            .background(Colors.init().white)
    }
}

#Preview {
    var config = Configuration()
    return OrderDetailView(orderId: 1).environmentObject(CoffeeModel(webservice: WebService(baseURL: config.environment.baseURL)))
}
