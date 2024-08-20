//
//  HelloCofeeE2ETests.swift
//  HelloCofeeE2ETests
//
//  Created by Jose M on 20/8/24.
//

import XCTest

final class when_app_is_launched_with_no_orders: XCTestCase {
    
    func test_should_make_sure_no_orders_message_is_displayed() throws {
    let app = XCUIApplication()
    continueAfterFailure = false
        app.launchEnvironment = ["ENV": "TEST"]
        app.launch()
        
        XCTAssertEqual("No orders available!", app.staticTexts["noOrdersText"].label)
    }

}
