//
// Created by Сергей Махленко on 08.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name
let AccessKey = "nOLcOHUH7Ts4Cmd04SfIikzffu3i7g9OqAiReZJSAoA"
let SecretKey = "XM2UQisS3ZUPEJQLxAgwKtXpxevIrqVonKadTLcZKj8"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
let AuthURLString = "https://unsplash.com/oauth"
// swiftlint:enable identifier_name

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let authURLString: String

    static var standard: AuthConfiguration {
        AuthConfiguration(
            accessKey: AccessKey,
            secretKey: SecretKey,
            redirectURI: RedirectURI,
            accessScope: AccessScope,
            authURLString: AuthURLString)
    }

    init(
        accessKey: String,
        secretKey: String,
        redirectURI: String,
        accessScope: String,
        authURLString: String
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.authURLString = authURLString
    }
}
