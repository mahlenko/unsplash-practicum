//
// Created by Сергей Махленко on 14.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation

class UserProfileRequest {
    static let shared = UserProfileRequest()
    private let network = NetworkService.shared

    private (set) var profile: UserProfile?

    static let didNotificationName = Notification.Name(rawValue: "UserProfileNotification")

    func fetchUserProfile(username: String, token: String, completion: @escaping (Result<UserProfileModel, Error>) -> Void) {
        let headers = [(key: "Authorization", value: "Bearer \(token)")]
        network.fetch(method: .GET, urlComponent: fetchUrlComponent(username: username), headers: headers) { result in
            switch result {
            case .success(let data):
                do {
                    let userProfileModel = try JSONDecoder().decode(UserProfileModel.self, from: data)

                    if let userProfileURL = URL(string: userProfileModel.profileImage.medium) {
                        self.profile = UserProfile.init(pictureURL: userProfileURL)
                    }

                    completion(.success(userProfileModel))

                    // отправим уведомление
                    NotificationCenter.default.post(
                        name: UserProfileRequest.didNotificationName,
                        object: self,
                        userInfo: ["userProfile": userProfileModel])
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func fetchUrlComponent(username: String) -> URLComponents {
        guard
            let url = URL(string: network.configuration.baseUrl + "/users/\(username)"),
            let urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            fatalError("Oops, something went wrong. Failed to create a link to get a user profile..")
        }

        return urlComponent
    }
}
