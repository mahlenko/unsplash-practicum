//
// Created by Сергей Махленко on 08.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import UIKit

final class AuthViewController: UIViewController {
    weak var delegate: AuthViewControllerDelegate?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "webViewSegue":
            guard let webViewVC = segue.destination as? WebViewViewController else { return }
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
