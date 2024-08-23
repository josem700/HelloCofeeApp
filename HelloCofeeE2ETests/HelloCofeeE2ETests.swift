//
//  HelloCofeeE2ETests.swift
//  HelloCofeeE2ETests
//
//  Created by Jose M on 20/8/24.
//

import XCTest

final class when_adding_a_new_coffee_order: XCTestCase{
    private var app: XCUIApplication!
    
    //Se llama antes de cada test
    override func setUp() {
        app = XCUIApplication()
        continueAfterFailure = false
        app.launchEnvironment = ["ENV": "TEST"]
        app.launch()
    
        //Ir a pantalla anadir orden
        app.buttons["addNewOrderButton"].tap()
        //Rellenar campos de texto
        let nameTextField = app.textFields["name"]
        let coffeeNameTextField = app.textFields["coffeeName"]
        let priceTextField = app.textFields["price"]
        let placeOrderButton = app.buttons["placeOrderButton"]
        
        nameTextField.tap()
        nameTextField.typeText("Antonio")
        
        coffeeNameTextField.tap()
        coffeeNameTextField.typeText("Capucchino")
        
        priceTextField.tap()
        priceTextField.typeText("2.20")
        
        placeOrderButton.tap()
    }
    
    func test_should_display_coffee_order_in_list_successfully() throws {
        XCTAssertEqual("Antonio", app.staticTexts["orderNameText"].label)
        XCTAssertEqual("Capucchino (Medium)", app.staticTexts["coffeeNameAndSizeText"].label)
        XCTAssertEqual("2,20 €", app.staticTexts["coffeePriceText"].label)
    }
    
    //Se llama despues de cada test
    override func tearDown() {
        Task{
            guard let url = URL(string: "/test/clear-orders", relativeTo: URL(string: "https://island-bramble.glitch.me")!) else {return}
            let (_,_) = try! await URLSession.shared.data(from: url)
        }
    }
}

final class when_app_is_launched_with_no_orders: XCTestCase {
    
    func test_should_make_sure_no_orders_message_is_displayed() throws {
        let app = XCUIApplication()
        continueAfterFailure = false
        app.launchEnvironment = ["ENV": "TEST"]
        app.launch()
        
        XCTAssertEqual("No orders available!", app.staticTexts["noOrdersText"].label)
    }

}
