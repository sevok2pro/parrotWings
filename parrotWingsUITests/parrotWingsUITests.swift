//
//  parrotWingsUITests.swift
//  parrotWingsUITests
//
//  Created by seva on 10/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import XCTest

class parrotWingsUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAuthorizeAndSendMoney() {
        let app = XCUIApplication()
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .textField).element.tap()
        element.children(matching: .textField).element.typeText("qwe")
        element.children(matching: .secureTextField).element.tap()
        element.children(matching: .secureTextField).element.typeText("qwe")
        app.buttons["Авторизоваться"].tap()
        app.buttons["Перевести PW"].tap()
        app.tables["Empty list"].children(matching: .searchField).element.tap()
        app.tables["Empty list"].children(matching: .searchField).element.typeText("q")
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["qwejdfajshfjksd"]/*[[".cells.staticTexts[\"qwejdfajshfjksd\"]",".staticTexts[\"qwejdfajshfjksd\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Отправить"].tap()
        app.buttons["На главный экран"].tap()
        app.buttons["Выйти из приложения"].tap()
    }

    func testRegister() {
        let app = XCUIApplication()
        app.tabBars.buttons["Регистрация"].tap()
        let email = String("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".shuffled())
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .textField).element.tap()
        element.children(matching: .textField).element.typeText(email)
        element.children(matching: .secureTextField).element(boundBy: 0).tap()
        element.children(matching: .secureTextField).element(boundBy: 0).typeText("qwe")
        element.children(matching: .secureTextField).element(boundBy: 1).tap()
        element.children(matching: .secureTextField).element(boundBy: 1).typeText("qwe")
        app.buttons["Зарегестрироваться"].tap()
        app.buttons["Перевести PW"].tap()
        app.tables["Empty list"].children(matching: .searchField).element.tap()
        app.tables["Empty list"].children(matching: .searchField).element.typeText("qwe")
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["qwe"]/*[[".cells.staticTexts[\"qwe\"]",".staticTexts[\"qwe\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Отправить"].tap()
        app.buttons["На главный экран"].tap()
        app.buttons["Выйти из приложения"].tap()
    }
}
