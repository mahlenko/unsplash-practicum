//
// Created by Сергей Махленко on 18.02.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import UnsplashPracticum
import Foundation

class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled = false
    var view: WebViewViewControllerProtocol?

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didUpdateProgressValue(_ newValue: Double) {
    }

    func code(from url: URL) -> String? {
        nil
    }
}
