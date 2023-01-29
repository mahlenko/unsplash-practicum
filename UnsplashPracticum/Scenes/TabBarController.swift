//
// Created by Сергей Махленко on 29.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    override func awakeFromNib() {
        super.awakeFromNib()

        let storyboard = UIStoryboard(name: "Main", bundle: .main)

        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Profile", comment: ""),
            image: UIImage(named: "profile-bar"),
            selectedImage: nil
        )

        viewControllers = [imagesListViewController, profileViewController]
    }
}
