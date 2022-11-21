//
// Created by Сергей Махленко on 11.11.2022.
// Copyright (c) 2022 ru.app-demo.unsplash. All rights reserved.
//
import UIKit

extension UIView {
    func gradient(
        colors: [CGColor],
        startPoint: CGPoint = CGPoint(x: 0, y: 0),
        endPoint: CGPoint = CGPoint(x: 0, y: 1),
        name: String = "default"
    ) {
        if let sublayers = layer.sublayers {
            sublayers.forEach { layer in
                // удаляем градиент если уже добавляли его
                if layer is CAGradientLayer && layer.name == name {
                    layer.removeFromSuperlayer()
                }
            }
        }

        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.locations = [0.0, 1.0]
        gradient.colors = colors
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.name = name

        layer.backgroundColor = .none
        layer.insertSublayer(gradient, at: 0)
        layer.setNeedsLayout()
    }
}
