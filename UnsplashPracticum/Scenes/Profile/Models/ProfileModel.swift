//
// Created by Сергей Махленко on 12.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation

struct ProfileModel: Decodable {
    let username: String
    let name: String
    let firstName: String
    let lastName: String
    let profileImage: ProfileImageModel

    private enum CodingKeys: String, CodingKey {
        case username
        case name
        case firstName = "first_name"
        case lastName = "last_name"
        case profileImage = "profile_image"
    }
}
