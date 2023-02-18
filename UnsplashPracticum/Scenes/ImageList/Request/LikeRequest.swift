//
// Created by Сергей Махленко on 31.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation

class LikeRequest {
    private let network = NetworkService.shared

    func sendChangeLike(id: String, currentStatus: Bool, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let token = OAuth2TokenStorage().userToken else { return }

        network.fetch(
            method: currentStatus ? .DELETE : .POST,
            urlComponent: URLComponentRequest(for: id),
            headers: [(key: "Authorization", value: "Bearer \(token)")]
        ) { result in
            switch result {
            case .success:
                completion(.success(!currentStatus))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func URLComponentRequest(for id: String) -> URLComponents {
        guard
            let url = URL(string: network.configuration.baseUrl + "/photos/\(id)/like"),
            let component = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            fatalError("Oops, something went wrong. Failed to create a link for like photo.")
        }

        return component
    }
}
