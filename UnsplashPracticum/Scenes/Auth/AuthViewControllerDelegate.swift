//
// Created by Сергей Махленко on 12.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ viewController: AuthViewController, didAuthenticateWithCode code: String)
}
