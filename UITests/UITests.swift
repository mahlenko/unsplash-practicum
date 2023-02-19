//
//  UITests.swift
//  UITests
//
//  Created by Сергей Махленко on 18.02.2023.
//  Copyright © 2023 ru.app-demo.unsplash. All rights reserved.
//

import XCTest

final class UITests: XCTestCase {
    private let app = XCUIApplication() // переменная приложения

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launch()
    }

    func testAuth() throws {
        // Нажать кнопку авторизации
        app.buttons["Authenticate"].tap()

        // Подождать, пока экран авторизации открывается и загружается
        let webView = app.webViews["UnsplashWebViewAuth"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))

        // Ввести данные в форму
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))

        loginTextField.tap()
        loginTextField.typeText("<Email>")
        // webView.swipeUp() // не работает, не сбрасывает фокус с поля, клавиатура остается
        app.toolbars.buttons["Done"].tap()

        let passwordSecureField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordSecureField.waitForExistence(timeout: 5))

        passwordSecureField.tap()
        passwordSecureField.typeText("<password>")
        app.toolbars.buttons["Done"].tap()

        // Нажать кнопку логина
        webView.buttons["Login"].tap()

        // Подождать, пока открывается экран ленты
        let cell = app.tables.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }

    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()

        XCTAssertTrue(app.staticTexts["username"].exists)
        XCTAssertTrue(app.staticTexts["nickname"].exists)

        app.buttons["logoutButton"].tap()

        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Yes"].tap()
    }
}
