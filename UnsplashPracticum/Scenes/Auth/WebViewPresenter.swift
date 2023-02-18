//
// Created by Сергей Махленко on 18.02.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol?

    func viewDidLoad() {
        guard var urlComponent = URLComponents(string: "\(Constant.unsplashOauthURL.rawValue)/authorize") else {
            return
        }

        urlComponent.queryItems = [
            URLQueryItem(name: "client_id", value: Constant.accessKey.rawValue),
            URLQueryItem(name: "redirect_uri", value: Constant.redirectURI.rawValue),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constant.accessScope.rawValue)
        ]

        guard let url = urlComponent.url else { return }
        let request = URLRequest(url: url)

        didUpdateProgressValue(0)

        view?.load(request: request)
    }

    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)

        view?.setProgressHidden(shouldHideProgress(for: newProgressValue))
    }

    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }

    func code(from url: URL) -> String? {
        guard
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" }),
            let code = codeItem.value
        else { return nil }

        return code
    }
}
