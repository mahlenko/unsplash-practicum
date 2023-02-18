//
// Created by Сергей Махленко on 08.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ viewController: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    weak var delegate: AuthViewControllerDelegate?

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "webViewSegue":
            guard let webViewVC = segue.destination as? WebViewViewController else { return }
            webViewVC.modalPresentationStyle = .fullScreen

            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewVC.presenter = webViewPresenter
            webViewPresenter.view = webViewVC
            webViewVC.delegate = self
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ webViewVC: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }

    func webViewViewControllerDidCancel(_ webViewVC: WebViewViewController) {
        dismiss(animated: true)
    }
}
