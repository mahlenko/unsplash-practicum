//
// Created by Сергей Махленко on 18.02.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation

protocol AuthHelperProtocol {
    func tokenUrlComponent(code: String) -> URLComponents
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
}
