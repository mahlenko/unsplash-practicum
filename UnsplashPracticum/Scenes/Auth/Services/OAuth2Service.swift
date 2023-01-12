//
// Created by Сергей Махленко on 09.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation

class OAuth2Service: NetworkService {
    /// Получение токена авторизации пользователя
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        fetch(method: .POST, urlComponent: fetchUrlComponent(code: code)) { result in
            switch result {
            // произошла ошибка при получении данных
            case .failure(let error):
                completion(.failure(error))

            // запрос выполнен успешно, вытаскиваем токен
            case .success(let data):
                do {
                    let response = try JSONDecoder()
                        .decode(OAuthTokenResponseBody.self, from: data) as OAuthTokenResponseBody

                    completion(.success(response.accessToken))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }

    // MARK: - Private methods
    private func fetchUrlComponent(code: String) -> URLComponents {
        guard
            let url = URL(string: "\(Constant.unsplashOauthURL.rawValue)/token"),
            var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            fatalError("Oops, something went wrong.")
        }

        urlComponent.queryItems = [
            URLQueryItem(name: "client_id", value: Constant.accessKey.rawValue),
            URLQueryItem(name: "client_secret", value: Constant.secretKey.rawValue),
            URLQueryItem(name: "redirect_uri", value: Constant.redirectURI.rawValue),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]

        return urlComponent
    }
}
