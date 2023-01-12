//
// Created by Сергей Махленко on 08.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import UIKit

final class AuthViewController: UIViewController {
//    var tokenStorage: OAuth2Token

    //var delegate: WebViewViewControllerDelegate?
    var delegate: AuthViewControllerDelegate?

//    init(storage: OAuth2Token) {
//        tokenStorage = storage
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        if let token = tokenStorage.userToken {
//            print("User token: \(token)")
//        }
//    }

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
