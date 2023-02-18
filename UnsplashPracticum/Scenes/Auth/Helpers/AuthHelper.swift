//
// Created by Сергей Махленко on 18.02.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation

class AuthHelper: AuthHelperProtocol {
    let configuration: AuthConfiguration

    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }

    func authRequest() -> URLRequest {
        URLRequest(url: authUrl())
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

    func tokenUrlComponent(code: String) -> URLComponents {
        guard var urlComponent = URLComponents(string: configuration.authURLString + "/token") else {
            fatalError("Error configuration by token.")
        }

        urlComponent.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "client_secret", value: configuration.secretKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code)
        ]

        return urlComponent
    }

    private func authUrl() -> URL {
        guard var urlComponent = URLComponents(string: configuration.authURLString + "/authorize") else {
            fatalError("Error configuration by auth.")
        }

        urlComponent.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "scope", value: configuration.accessScope),
            URLQueryItem(name: "response_type", value: "code")
        ]

        return urlComponent.url!
    }
}
