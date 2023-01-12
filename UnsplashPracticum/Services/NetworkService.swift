//
// Created by Сергей Махленко on 09.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation

enum FetchMethod {
    case GET
    case POST
}

class NetworkService {
    private enum NetworkError: LocalizedError {
        case unsplashErrorCode

        public var errorDescription: String? {
            switch self {
            case .unsplashErrorCode:
                // todo: попробовать сделать локализацию ошибок, когда нибудь :D
                return "Unsplash API returned an error code."
            }
        }
    }

    private let urlSession: URLSession

    init(urlSession: URLSession?) {
        self.urlSession = urlSession ?? URLSession.shared
    }

    func fetch(method: FetchMethod, urlComponent: URLComponents, headers: [(key: String, value: String)] = [], completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = urlComponent.url else { fatalError("Oops, something went wrong.")}

        var request = URLRequest(url: url)
        request.httpMethod = "\(method)"

        if method != .GET, let query = urlComponent.query {
            request.httpBody = Data(query.utf8)
        }

        if !headers.isEmpty {
            headers.forEach { item in
                request.setValue(item.value, forHTTPHeaderField: item.key)
            }
        }

        urlSession.dataTask(with: request) { data, response, error in
            if let error = error { completion(.failure(error)) }

            if let response = response as? HTTPURLResponse,
                response.statusCode <= 199,
                response.statusCode >= 300 {
                completion(.failure(NetworkError.unsplashErrorCode))
            }

            guard let data = data else { return }
            completion(.success(data))
        }
        .resume()
    }
}
