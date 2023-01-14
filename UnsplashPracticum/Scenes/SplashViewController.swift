//
// Created by Сергей Махленко on 09.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation
import UIKit

class SplashViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    private let session = URLSession.shared
    private var tokenStorage: OAuth2Token = OAuth2TokenStorageUserDefault()
    private let authScreenSegueIdentifier = "ShowAuthenticationScreen"

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (tokenStorage.userToken) != nil {
            switchToTabBarController()
        } else {
            showScreenLogin()
        }
    }
}

extension SplashViewController {
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case authScreenSegueIdentifier:
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(authScreenSegueIdentifier)") }

            viewController.delegate = self
        default:
            super.prepare(for: segue, sender: sender)
        }
    }

    private func showScreenLogin() {
        performSegue(withIdentifier: "ShowAuthenticationScreen", sender: self)
    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }

        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")

        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ viewController: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) {
            self.getTokenAuthorize(code: code)
        }
    }

    private func getTokenAuthorize(code: String ) {
        let service = OAuth2Service(urlSession: URLSession.shared)

        service.fetchAuthToken(code: code) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    guard let self else { return }
                    self.tokenStorage.userToken = token
                    self.switchToTabBarController()
                    UIBlockingProgressHUD.dismiss()
                case .failure:
                    break
                }
            }
        }
    }
}
