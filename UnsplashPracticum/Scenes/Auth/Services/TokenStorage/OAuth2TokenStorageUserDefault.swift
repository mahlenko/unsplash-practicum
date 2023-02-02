//
// Created by Сергей Махленко on 09.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage: OAuth2Token {
    let keyStorage = "authToken"

    let keychain = KeychainWrapper.standard

    var userToken: String? {
        get { KeychainWrapper.standard.string(forKey: keyStorage) }

        set {
            if let newValue {
                keychain.set(newValue, forKey: keyStorage)
            } else {
                keychain.removeObject(forKey: keyStorage)
            }
        }
    }
}
