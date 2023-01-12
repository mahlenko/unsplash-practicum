//
// Created by Сергей Махленко on 12.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation

class GetProfile: NetworkService {
    func fetchUserProfile(token: String, completion: @escaping (Result<ProfileModel, Error>) -> ()) {
        let headers = [(key: "Authorization", value: "Bearer \(token)")]
        fetch(method: .GET, urlComponent: fetchUrlComponent(), headers: headers) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let profile = try JSONDecoder()
                        .decode(ProfileModel.self, from: data) as ProfileModel

                    completion(.success(profile))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }

    private func fetchUrlComponent() -> URLComponents {
        guard
                let url = URL(string: "\(Constant.unsplashBaseURL.rawValue)/me"),
                let urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            fatalError("Oops, something went wrong. Failed to create a link to get a user profile..")
        }

        return urlComponent
    }
}