//
// Created by Сергей Махленко on 21.11.2022.
// Copyright (c) 2022 ru.app-demo.unsplash. All rights reserved.
//

import UIKit
import Drops
import Kingfisher
import WebKit

final class ProfileViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    // MARK: - UI elements
    private let avatarImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let nicknameLabel = UILabel()
    private let biographyLabel = UILabel()
    private let logoutButton = UIButton()

    private let profileRequest = ProfileRequest.shared
    private let userProfileRequest = UserProfileRequest.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        configureScreen()

        ShimmerPlaceholder.show(view: avatarImageView)

        [usernameLabel, nicknameLabel, biographyLabel].forEach { label in
            ShimmerPlaceholder.show(view: label)
            label.text = ""
        }

        guard let profile = profileRequest.profile else { return }
        updateProfileDetails(profile: profile)

        if let userPictureURL = userProfileRequest.profile?.pictureURL {
            updateUserAvatar(url: userPictureURL)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addObserver()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObserver()
    }

    @IBAction func tapLogoutButton(_ sender: Any) {
        // нужно использовать делегат и доступ к OAuth2Token.
        // На скорую руку для тестов пока так, 10 спринт не требует разлогиниться

        let message = "Действительно хотите выйти?"
        let alertView = UIAlertController(title: "Пока, пока!", message: message, preferredStyle: .alert)
        let buttonNo = UIAlertAction(title: "Нет", style: .cancel)
        let buttonYes = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self else { return }
            self.userLogout()
        }

        alertView.addAction(buttonNo)
        alertView.addAction(buttonYes)

        present(alertView, animated: true)
    }

    private func userLogout() {
        guard let window = UIApplication.shared.windows.first else { return }

        OAuth2TokenStorage().userToken = nil
        cleanCookies()

        let startScreen = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "StartScreen")

        window.rootViewController = startScreen
    }

    private func cleanCookies() {
        // Очищаем все куки из хранилища.
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища.
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища.
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(
                    ofTypes: record.dataTypes,
                    for: [record]) {}
            }
        }
    }

    private func updateProfileDetails(profile: Profile) {
        usernameLabel.text = profile.name
        nicknameLabel.text = profile.loginName
        biographyLabel.text = profile.biography

        [usernameLabel, nicknameLabel, biographyLabel].forEach { label in
            ShimmerPlaceholder.hide(view: label)
        }
    }

    @objc private func getUserAvatarByNotification(notification: Notification) {
        guard isViewLoaded,
            let userInfo = notification.userInfo,
            let userProfile = userInfo["userProfile"] as? UserProfileModel,
            let userPictureUrl = URL(string: userProfile.profileImage.medium)
        else { return }

        updateUserAvatar(url: userPictureUrl)
    }

    private func updateUserAvatar(url: URL) {
        // получить изображение пользователя используя Kingfisher
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder-userPicture")) { [weak self] _ in
                guard let self else { return }
                ShimmerPlaceholder.hide(view: self.avatarImageView)
                self.avatarImageView.layer.cornerRadius = self.avatarImageView.layer.frame.height / 2
        }
    }

    // MARK: - UI Configuration

    func configureScreen() {
        view.backgroundColor = UIColor.backgroundBrand

        configureAvatarImageView()
        configureUsernameLabel()
        configureNicknameLabel()
        configureBiographyLabel()
        configureLogoutButton()

        setConstraints()
    }

    func configureAvatarImageView() {
        avatarImageView.layer.cornerRadius = avatarImageView.layer.frame.height / 2
        avatarImageView.clipsToBounds = true

        avatarImageView.contentMode = .scaleAspectFill

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
    }

    func configureUsernameLabel() {
        usernameLabel.text = "Имя Фамилия"
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        usernameLabel.textColor = UIColor.whiteBrand

        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameLabel)
    }

    func configureNicknameLabel() {
        nicknameLabel.text = "@nickname"
        nicknameLabel.font = UIFont.systemFont(ofSize: 13)
        nicknameLabel.textColor = UIColor.grayBrand

        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nicknameLabel)
    }

    func configureBiographyLabel() {
        biographyLabel.text = "Биография пользователя"
        biographyLabel.font = UIFont.systemFont(ofSize: 13)
        biographyLabel.textColor = UIColor.whiteBrand

        biographyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(biographyLabel)
    }

    func configureLogoutButton() {
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setImage(UIImage(named: "logout-active"), for: .normal)
        view.addSubview(logoutButton)

        logoutButton.addTarget(self, action: #selector(tapLogoutButton), for: .touchUpInside)
    }

    func setConstraints() {
        let trailingAnchor = view.layoutMarginsGuide.trailingAnchor
        let leadingAnchor = view.layoutMarginsGuide.leadingAnchor
        let safeAreaTopAnchor = view.safeAreaLayoutGuide.topAnchor

        NSLayoutConstraint.activate([
            // user picture
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatarImageView.topAnchor.constraint(equalTo: safeAreaTopAnchor, constant: 32),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),

            // user name
            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            usernameLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),

            // nickname
            nicknameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nicknameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),

            // biography
            biographyLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            biographyLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),

            // logout
            logoutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            logoutButton.topAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: -11)
        ])
    }
}

extension ProfileViewController {
    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(getUserAvatarByNotification(notification:)),
            name: UserProfileRequest.didNotificationName,
            object: nil)
    }

    private func removeObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: UserProfileRequest.didNotificationName,
            object: nil)
    }
}
