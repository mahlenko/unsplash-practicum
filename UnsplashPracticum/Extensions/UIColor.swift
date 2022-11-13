//
// Created by Сергей Махленко on 09.11.2022.
// Copyright (c) 2022 ru.app-demo.unsplash. All rights reserved.
//

import UIKit

extension UIColor {
    static var backgroundBrand: UIColor { UIColor(named: "Background") ?? .black.withAlphaComponent(50.0) }
    static var blackBrand: UIColor { UIColor(named: "Black") ?? .black }
    static var blueBrand: UIColor { UIColor(named: "Blue") ?? .blue }
    static var grayBrand: UIColor { UIColor(named: "Gray") ?? .gray }
    static var redBrand: UIColor { UIColor(named: "Red") ?? .red }
    static var whiteBrand: UIColor { UIColor(named: "White") ?? .white }
    static var whiteTransparentBrand: UIColor { UIColor(named: "White") ?? .white.withAlphaComponent(50.0) }
}
