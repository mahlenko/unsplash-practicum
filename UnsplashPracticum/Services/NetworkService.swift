//
// Created by Сергей Махленко on 09.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation

enum FetchMethod: String {
    case GET
    case POST
}

class NetworkService {
    var lastUrlComponent: URLComponents?
    var task: URLSessionTask?

    private enum NetworkError: LocalizedError {
        case unsplashErrorCode

        public var errorDescription: String? {
            switch self {
            case .unsplashErrorCode:
                // TODO: попробовать сделать локализацию ошибок, когда нибудь :D
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

        //
        assert(Thread.isMainThread)
        guard urlComponent != lastUrlComponent else { return }
        task?.cancel()
        lastUrlComponent = urlComponent

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if method != .GET, let query = urlComponent.query {
            request.httpBody = Data(query.utf8)
        }

        if !headers.isEmpty {
            headers.forEach { item in
                request.setValue(item.value, forHTTPHeaderField: item.key)
            }
        }

        let task = urlSession.dataTask(with: request) { data, response, error in
            self.lastUrlComponent = nil
            self.task = nil

            if let error = error { completion(.failure(error)) }

            if let response = response as? HTTPURLResponse,
                response.statusCode <= 199,
                response.statusCode >= 300 {
                completion(.failure(NetworkError.unsplashErrorCode))
            }

            guard let data = data else { return }
            completion(.success(data))
        }

        self.task = task
        task.resume()
    }
}
