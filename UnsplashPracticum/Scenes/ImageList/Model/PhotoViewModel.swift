//
// Created by Сергей Махленко on 30.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation

struct PhotoViewModel {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let blurHash: String
    let thumbImageURL: String
    let largeImageURL: String
    let downloadURL: String
    var isLiked: Bool

    static func convert(model: PhotoModel) -> PhotoViewModel {
        PhotoViewModel(
            id: model.id,
            size: CGSize(width: model.width, height: model.height),
            createdAt: DateFormatter().date(from: model.createdAt),
            welcomeDescription: model.description,
            blurHash: model.blurHash,
            thumbImageURL: model.urls.thumb,
            largeImageURL: model.urls.full,
            downloadURL: model.links.download,
            isLiked: model.likedByUser
        )
    }

    mutating func updateLike(like: Bool) {
        isLiked = like
    }
}
