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
}
