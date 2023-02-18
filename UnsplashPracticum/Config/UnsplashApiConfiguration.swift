//
// Created by Сергей Махленко on 18.02.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation

struct UnsplashApiConfiguration {
    let baseUrl: String

    static var standard: UnsplashApiConfiguration {
        UnsplashApiConfiguration(baseUrl: "https://api.unsplash.com")
    }

    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
}
