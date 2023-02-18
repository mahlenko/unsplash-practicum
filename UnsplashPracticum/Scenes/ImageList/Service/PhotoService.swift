//
// Created by Сергей Махленко on 29.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation

class PhotoService {
    static let shared = PhotoService()
    private let network = NetworkService.shared

    var photos: [PhotoViewModel] = []
    private let formatter = ISO8601DateFormatter()
    private var currentPage: Int?

    static let didChangeNotification = Notification.Name(rawValue: "PhotoListRequestDidChange")

    func fetchPhotoNextPage(completion: @escaping (Result<[PhotoModel], Error>) -> Void) {
        UIBlockingProgressHUD.show()
        let urlComponent = getUrlComponent()

        guard let token = OAuth2TokenStorage().userToken else {
            fatalError("User token not found.")
        }

        let headers = [(key: "Authorization", value: "Bearer \(token)")]

        network.fetch(
            method: .GET,
            urlComponent: urlComponent,
            headers: headers) { [weak self] result in
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()

                switch result {
                case .success(let data):
                    guard let self else {
                        return
                    }
                    do {
                        // декодируем результат и добавим фото в массив
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let photos = try decoder.decode([PhotoModel].self, from: data)

                        photos.forEach { model in
                            self.photos.append(
                                PhotoViewModel.convert(model: model, dateFormatter: self.formatter)
                            )
                        }

                        // сохраним номер последней полученной страницы
                        if let page = urlComponent.queryItems?.first(where: { $0.name == "page" })?.value {
                            self.currentPage = Int(page)
                        }

                        // отправляем уведомление
                        NotificationCenter.default.post(name: PhotoService.didChangeNotification, object: self)
                        completion(.success(photos))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    private func getUrlComponent() -> URLComponents {
        guard
            let url = URL(string: network.configuration.baseUrl + "/photos"),
            var component = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            fatalError("Oops, something went wrong. Failed to create a link to get a photos.")
        }

        var page = 1
        if let currentPage {
            page = currentPage + 1
        }

        component.queryItems = [URLQueryItem(name: "page", value: "\(page)")]

        return component
    }
}
