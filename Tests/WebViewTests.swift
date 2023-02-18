//
//  WebViewTests.swift
//  UnsplashPracticum
//
//  Created by Сергей Махленко on 18.02.2023.
//  Copyright © 2023 ru.app-demo.unsplash. All rights reserved.
//

@testable import UnsplashPracticum
import XCTest

final class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        _ = viewController.view

        XCTAssertTrue(presenter.viewDidLoadCalled)
    }

    func testPresenterCallsLoadRequest() {
        let webViewViewControllerSpy = WebViewViewControllerSpy()
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        webViewViewControllerSpy.presenter = presenter
        presenter.view = webViewViewControllerSpy

        presenter.viewDidLoad()

        XCTAssert(webViewViewControllerSpy.loadRequestCalled)
    }

    func testProgressVisibleWhenLessThenOne() {
        let presenter = WebViewPresenter(authHelper: AuthHelper())

        let shouldHideProgress = presenter.shouldHideProgress(for: 0.6)

        XCTAssertFalse(shouldHideProgress)
    }

    func testProgressHiddenWhenOne() {
        let presenter = WebViewPresenter(authHelper: AuthHelper())

        let shouldHideProgress = presenter.shouldHideProgress(for: 1.0)

        XCTAssertTrue(shouldHideProgress)
    }

    func testAuthHelperAuthURL() {
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)

        let authUrl = authHelper.authUrl()
        let urlString = authUrl.absoluteString

        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
        XCTAssertTrue(urlString.contains("code"))
    }

    func testCodeFromURL() {
        let authHelper = AuthHelper()
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [ URLQueryItem(name: "code", value: "test code") ]

        let code = authHelper.code(from: urlComponents.url!)

        XCTAssertEqual(code, "test code")
    }
}
