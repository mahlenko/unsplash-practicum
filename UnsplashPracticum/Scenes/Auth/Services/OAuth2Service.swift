//
// Created by Сергей Махленко on 09.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation

class OAuth2Service: NetworkService {
    let authHelper: AuthHelperProtocol

    override init(urlSession: URLSession = .shared, configuration: UnsplashApiConfiguration = .standard) {
        authHelper = AuthHelper()
        super.init(urlSession: urlSession, configuration: configuration)
    }

    /// Получение токена авторизации пользователя
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        fetch(method: .POST, urlComponent: authHelper.tokenUrlComponent(code: code)) { result in
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
}
