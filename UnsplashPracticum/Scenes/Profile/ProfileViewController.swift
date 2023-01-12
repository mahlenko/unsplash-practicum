//
// Created by Сергей Махленко on 21.11.2022.
// Copyright (c) 2022 ru.app-demo.unsplash. All rights reserved.
//

import UIKit

final class ProfileViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var avatar: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var nicknameLabel: UILabel!
    @IBOutlet private weak var logoutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tapLogoutButton(_ sender: Any) {
        // нужно использовать делегат и доступ к OAuth2Token.
        // На скорую руку для тестов пока так, 10 спринт не требует разлогиниться

        let message = "Действительно хотите выйти?"
        let alertView = UIAlertController(title: "Пока, пока!", message: message, preferredStyle: .alert)
        let buttonNo = UIAlertAction(title: "Нет", style: .cancel)
        let buttonYes = UIAlertAction(title: "Да", style: .default) { [weak self] action in
            guard let self else { return }
            self.userLogout()
        }

        alertView.addAction(buttonNo)
        alertView.addAction(buttonYes)

        present(alertView, animated: true)
    }

    private func userLogout() {
        guard let window = UIApplication.shared.windows.first else { return }

        OAuth2TokenStorageUserDefault().userToken = nil

        let startScreen = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "StartScreen")

        window.rootViewController = startScreen
    }
}
