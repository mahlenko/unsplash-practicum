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
}
