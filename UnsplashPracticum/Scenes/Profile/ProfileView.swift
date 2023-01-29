//
// Created by Сергей Махленко on 29.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation
import UIKit

extension ProfileViewController {
    func configureScreen() {
        view.backgroundColor = UIColor.backgroundBrand

        configureAvatarImageView()
        configureUsernameLabel()
        configureNicknameLabel()
        configureBiographyLabel()
        configureLogoutButton()
    }

    func configureAvatarImageView() {
        avatarImageView.image = UIImage(named: "avatar")
        avatarImageView.layer.cornerRadius = 35
        avatarImageView.clipsToBounds = true

        avatarImageView.contentMode = .scaleAspectFill

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)

        // constraints
        avatarImageView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }

    func configureUsernameLabel() {
        usernameLabel.text = "Your name"

        usernameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        usernameLabel.textColor = UIColor.whiteBrand

        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameLabel)

        // constraints
        usernameLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
    }

    func configureNicknameLabel() {
        nicknameLabel.text = "@placeholder"

        nicknameLabel.font = UIFont.boldSystemFont(ofSize: 13)
        nicknameLabel.textColor = UIColor.grayBrand

        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nicknameLabel)

        // constraints
        nicknameLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        nicknameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8).isActive = true
    }

    func configureBiographyLabel() {
        biographyLabel.text = "Placeholder user biography."

        biographyLabel.font = UIFont.systemFont(ofSize: 13)
        biographyLabel.textColor = UIColor.whiteBrand

        biographyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(biographyLabel)

        // constraints
        biographyLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        biographyLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8).isActive = true
    }

    func configureLogoutButton() {
        logoutButton.setBackgroundImage(UIImage(named: "logout-active"), for: .normal)

        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)

        // constraints
        logoutButton.trailingAnchor.constraint(
            equalTo: view.layoutMarginsGuide.trailingAnchor,
            constant: -8)
            .isActive = true
        logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55).isActive = true

        logoutButton.addTarget(self, action: #selector(tapLogoutButton), for: .touchUpInside)
    }
}
