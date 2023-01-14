//
// Created by Сергей Махленко on 09.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation
import UIKit
import ProgressHUD

class SplashViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    private let session = URLSession.shared
    private var tokenStorage: OAuth2Token = OAuth2TokenStorageUserDefault()
    private let authScreenSegueIdentifier = "ShowAuthenticationScreen"

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = tokenStorage.userToken {
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

//    private func showScreenApp(token: String) {
//        GetProfile(urlSession: session).fetchUserProfile(token: token) { [weak self] result in
//            switch result {
//            case .failure(let error):
//                print(error.localizedDescription)
//            case .success(let profile):
//                // show profile screen
//                print(profile)
//                guard let self else { return }
//                DispatchQueue.main.async {
//                    self.switchToTabBarController()
//                }
//            }
//        }
//    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }

        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")

        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ viewController: AuthViewController, didAuthenticateWithCode code: String) {
        ProgressHUD.show()
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
                    ProgressHUD.dismiss()
                case .failure:
                    break
                }
            }
        }
    }
}
