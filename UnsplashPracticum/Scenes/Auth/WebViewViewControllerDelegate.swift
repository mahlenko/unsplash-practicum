//
// Created by Сергей Махленко on 08.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    /// Получили код авторизации
    func webViewViewController(_ webViewVC: WebViewViewController, didAuthenticateWithCode code: String)

    /// Пользователь нажал кнопку "назад" и отменил авторизацию
    func webViewViewControllerDidCancel(_ webViewVC: WebViewViewController)
}
