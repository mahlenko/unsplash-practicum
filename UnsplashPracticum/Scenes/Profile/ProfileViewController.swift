//
// Created by Сергей Махленко on 21.11.2022.
// Copyright (c) 2022 ru.app-demo.unsplash. All rights reserved.
//

import UIKit
import Drops
import Kingfisher

final class ProfileViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    // MARK: - UI elements
    internal var avatarImageView = UIImageView()
    internal var usernameLabel = UILabel()
    internal var nicknameLabel = UILabel()
    internal var biographyLabel = UILabel()
    internal var logoutButton = UIButton()

    private let profileRequest = ProfileRequest.shared
    private let userProfileRequest = UserProfileRequest.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        configureScreen()

        guard let profile = profileRequest.profile else { return }
        updateProfileDetails(profile: profile)

        if let userPictureURL = userProfileRequest.profile?.pictureURL {
            updateUserAvatar(url: userPictureURL)
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        addObserver()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addObserver()
    }

    deinit { removeObserver() }

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

        let startScreen = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "StartScreen")

        window.rootViewController = startScreen
    }

    private func updateProfileDetails(profile: Profile) {
        usernameLabel.text = profile.name
        nicknameLabel.text = profile.loginName
        biographyLabel.text = profile.biography
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
        avatarImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder-userPicture"))
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
