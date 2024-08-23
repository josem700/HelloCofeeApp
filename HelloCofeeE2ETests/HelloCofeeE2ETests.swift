//
//  HelloCofeeE2ETests.swift
//  HelloCofeeE2ETests
//
//  Created by Jose M on 20/8/24.
//

import XCTest

final class when_updating_an_existing_order: XCTestCase {
    private var app: XCUIApplication!
    
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
    
    func test_should_update_order_successfully(){
        let orderList = app.collectionViews["orderList"]
        orderList.buttons["orderNameText-coffeeNameAndSizeText-coffeePriceText"].tap()
        
        app.buttons["editOrderButton"].tap()
        
        let nameTextField = app.textFields["name"]
        let coffeeNameTextField = app.textFields["coffeeName"]
        let priceTextField = app.textFields["price"]
        let placeOrderButton = app.buttons["placeOrderButton"]
        
        let _ = nameTextField.waitForExistence(timeout: 2.0)
        nameTextField.tap(withNumberOfTaps: 2, numberOfTouches: 1)
        nameTextField.typeText("Juan")
        
        let _ = coffeeNameTextField.waitForExistence(timeout: 2.0)
        coffeeNameTextField.tap(withNumberOfTaps: 2, numberOfTouches: 1)
        coffeeNameTextField.typeText("Expresso")
        
        let _ = priceTextField.waitForExistence(timeout: 2.0)
        priceTextField.tap(withNumberOfTaps: 2, numberOfTouches: 1)
        priceTextField.typeText("1.50")
        
        placeOrderButton.tap()
        
        XCTAssertEqual("Expresso", app.staticTexts["coffeeNameText"].label)
    }
    
    override func tearDown() {
        Task{
            guard let url = URL(string: "/test/clear-orders", relativeTo: URL(string: "https://island-bramble.glitch.me")!) else {return}
            let (_,_) = try! await URLSession.shared.data(from: url)
        }
    }
}

final class when_deleting_an_order: XCTestCase {
    private var app: XCUIApplication!
    
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
    
    func test_should_delete_order_successfully(){
        let collectionViewsQuery = XCUIApplication().collectionViews
        let cellsQuery = collectionViewsQuery.cells
        let element = cellsQuery.children(matching: .other).element(boundBy: 0).children(matching: .other).element
        element.swipeLeft()
        collectionViewsQuery.buttons["Delete"].tap()
        
        let orderList = app.collectionViews["orderList"]
        XCTAssertEqual(0, orderList.cells.count)
    }
    
    //Se llama despues de cada test para borrar la prueba de la base de datos
    override func tearDown() {
        Task{
            guard let url = URL(string: "/test/clear-orders", relativeTo: URL(string: "https://island-bramble.glitch.me")!) else {return}
            let (_,_) = try! await URLSession.shared.data(from: url)
        }
    }
}

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
