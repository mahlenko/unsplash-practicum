//
// Created by Сергей Махленко on 29.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation

struct UserProfileModel: Decodable {
    let profileImage: ProfileImagesModel

    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
