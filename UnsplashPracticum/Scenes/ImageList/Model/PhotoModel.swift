//
// Created by Сергей Махленко on 29.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation

struct PhotoModel: Decodable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let description: String?
    let blurHash: String
    let likedByUser: Bool
    let urls: PhotoURL
    let links: PhotoLink

    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case description
        case blurHash = "blur_hash"
        case likedByUser = "liked_by_user"
        case urls
        case links
    }
}
