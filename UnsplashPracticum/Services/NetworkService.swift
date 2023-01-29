//
// Created by Сергей Махленко on 09.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation

enum FetchMethod: String {
    case GET
    case POST
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

    private let urlSession: URLSession

    init(urlSession: URLSession?) {
        self.urlSession = urlSession ?? URLSession.shared
    }

    func fetch(method: FetchMethod, urlComponent: URLComponents, headers: [(key: String, value: String)] = [], completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = urlComponent.url else { fatalError("Oops, something went wrong.")}

        //
        assert(Thread.isMainThread)
        task?.cancel()

        var request = URLRequest(url: url)
        request.timeoutInterval = 2.0
        request.httpMethod = method.rawValue

        if method.rawValue != FetchMethod.GET.rawValue,
            let query = urlComponent.query {
            request.httpBody = Data(query.utf8)
        }

        if !headers.isEmpty {
            headers.forEach { item in
                request.setValue(item.value, forHTTPHeaderField: item.key)
            }
        }

        let task = urlSession.dataTask(with: request) { data, response, error in
            self.task = nil

            if let error = error { completion(.failure(error)) }

            if let response = response as? HTTPURLResponse,
                response.statusCode <= 199,
                response.statusCode >= 300 {
                completion(.failure(NetworkError.unsplashErrorCode))
            }

            // для запроса требуется авторизация
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(NetworkError.requiredAuthorization))
            }

            guard let data = data else { return }
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }

        self.task = task
        task.resume()
    }
}
