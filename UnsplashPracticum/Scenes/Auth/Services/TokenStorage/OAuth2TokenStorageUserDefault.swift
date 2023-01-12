//
// Created by Сергей Махленко on 09.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation

final class OAuth2TokenStorageUserDefault: OAuth2Token {
    let keyStorage = "authToken"

    var userToken: String? {
        get { UserDefaults.standard.string(forKey: keyStorage) }

        set {
            if let newValue {
                UserDefaults.standard.set(newValue, forKey: keyStorage)
            } else {
                UserDefaults.standard.removeObject(forKey: keyStorage)
            }
        }
    }
}
