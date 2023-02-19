//
// Created by Сергей Махленко on 08.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation

let unsplashAccessKey = "nOLcOHUH7Ts4Cmd04SfIikzffu3i7g9OqAiReZJSAoA"
let unsplashSecretKey = "XM2UQisS3ZUPEJQLxAgwKtXpxevIrqVonKadTLcZKj8"
let unsplashRedirectUri = "urn:ietf:wg:oauth:2.0:oob"
let unsplashScope = "public+read_user+write_likes"
let unsplashAuthUrl = "https://unsplash.com/oauth"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let authURLString: String

    static var standard: AuthConfiguration {
        AuthConfiguration(
            accessKey: unsplashAccessKey,
            secretKey: unsplashSecretKey,
            redirectURI: unsplashRedirectUri,
            accessScope: unsplashScope,
            authURLString: unsplashAuthUrl)
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
