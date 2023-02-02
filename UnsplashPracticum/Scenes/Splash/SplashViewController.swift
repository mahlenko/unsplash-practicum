//
// Created by Сергей Махленко on 09.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation
import UIKit
import Drops

class SplashViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    private let session = URLSession.shared
    private var profileRequest = ProfileRequest.shared

    private var tokenStorage: OAuth2Token = OAuth2TokenStorage()
    private let authScreenSegueIdentifier = "ShowAuthenticationScreen"

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        configureScreen()

        showAuthOrAppScreen()
    }
}

extension SplashViewController {
    private func showAuthOrAppScreen () {
        if let token = tokenStorage.userToken {
            fetchProfile(token: token)
        } else {
            showScreenLogin()
        }
    }

    private func showScreenLogin() {
        guard let authController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
        else { return }

        authController.modalPresentationStyle = .fullScreen
        authController.delegate = self

        present(authController, animated: true)
    }
}

extension SplashViewController {
    // переключение между флоу
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }

        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")

        window.rootViewController = tabBarController
    }

    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()

        profileRequest.fetchUserProfile(token: token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()

            switch result {
            case .success:
                guard let self else { return }
                guard let profile = self.profileRequest.profile else { return }
                self.fetchUserProfile(username: profile.username, token: token)

                self.switchToTabBarController()
            case .failure(let error):
                ErrorToast.show(
                    message: error.localizedDescription,
                    action: .init(icon: UIImage(systemName: "repeat")) { [weak self] in
                        guard let self else { return }
                        self.fetchProfile(token: token)
                        Drops.hideCurrent()
                    })
            }
        }
    }

    private func fetchUserProfile(username: String, token: String) {
        UserProfileRequest.shared.fetchUserProfile(username: username, token: token) { _ in }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ viewController: AuthViewController, didAuthenticateWithCode code: String) {
        getTokenAuthorize(code: code)
        dismiss(animated: true)
    }

    private func getTokenAuthorize(code: String ) {
        let service = OAuth2Service(urlSession: URLSession.shared)

        service.fetchAuthToken(code: code) { [weak self] result in
            switch result {
            case .success(let token):
                guard let self else { return }
                self.tokenStorage.userToken = token
                self.fetchProfile(token: token)
            case .failure(let error):
                ErrorToast.show(
                    message: error.localizedDescription,
                    title: "Ошибка авторизации",
                    action: .init(icon: UIImage(systemName: "repeat")) { [weak self] in
                        guard let self else { return }
                        self.getTokenAuthorize(code: code)
                        Drops.hideCurrent()
                    })
            }
        }
    }
}
