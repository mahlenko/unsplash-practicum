//
// Created by Сергей Махленко on 09.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation

enum FetchMethod: String {
    case GET
    case POST
    case DELETE
}

enum NetworkError: LocalizedError {
    case unsplashErrorCode
    case requiredAuthorization

    public var errorDescription: String? {
        switch self {
        case .unsplashErrorCode:
            return "Unsplash API returned an error code."
        case .requiredAuthorization:
            return "Required authorization."
        }
    }
}

class NetworkService {
    var task: URLSessionTask?
    var lastUrlComponents: URLComponents?

    private let session: URLSession
    static let shared = NetworkService()

    init(urlSession: URLSession = URLSession.shared) {
        session = urlSession
    }

    internal func fetch(method: FetchMethod, urlComponent: URLComponents, headers: [(key: String, value: String)] = [], completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = urlComponent.url else {
            fatalError("Oops, something went wrong.")
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        request.httpMethod = method.rawValue

        if method.rawValue != FetchMethod.GET.rawValue, let query = urlComponent.query {
            request.httpBody = Data(query.utf8)
        }

        if !headers.isEmpty {
            headers.forEach { item in
                request.setValue(item.value, forHTTPHeaderField: item.key)
            }
        }

        assert(Thread.isMainThread)
        if
            lastUrlComponents?.url == urlComponent.url,
            lastUrlComponents?.query == urlComponent.query,
            task != nil {
                return
            }

        let task = session.dataTask(with: request) { data, response, error in
            self.task = nil
            self.lastUrlComponents = nil

            DispatchQueue.main.async {
                if let error = error { completion(.failure(error)) }

                if let response = response as? HTTPURLResponse,
                    response.statusCode <= 199,
                    response.statusCode >= 300 {
                    return completion(.failure(NetworkError.unsplashErrorCode))
                }

                // для запроса требуется авторизация
                if let response = response as? HTTPURLResponse,
                    response.statusCode == 401 {
                    return completion(.failure(NetworkError.requiredAuthorization))
                }

                guard let data = data else { return }
                completion(.success(data))
            }
        }

        self.task = task
        lastUrlComponents = urlComponent
        task.resume()
    }
}
