//
// Created by Сергей Махленко on 29.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import UIKit

extension SplashViewController {
    func configureScreen() {
        view.backgroundColor = UIColor.backgroundBrand

        let logoImage = UIImageView(image: UIImage(named: "practicum-logo"))

        logoImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImage)

        logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        logoImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
}
