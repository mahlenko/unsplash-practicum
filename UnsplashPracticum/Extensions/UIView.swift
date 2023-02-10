//
// Created by Сергей Махленко on 11.11.2022.
// Copyright (c) 2022 ru.app-demo.unsplash. All rights reserved.
//
import UIKit

extension UIView {
    func shimmerAnimatePlaceholder(color: UIColor) {
        // не создаем повторные placeholders
        var cancel = false
        subviews.forEach { view in
            guard view.layer.sublayers?.first(where: { $0.name == Shimmer.name }) == nil else {
                cancel = true
                return
            }
        }
        guard cancel != true else { return }

        layer.layoutIfNeeded()
        let alphaColor = color.withAlphaComponent(0.3).cgColor

        // для плавного перехода градиента, добавим сначала дополнительный слой
        // с размером root, а уже в него добавим слой с градиетом большего по ширине view.
        // Таким образом градиет будет с более плавным переходом.
        let gradientView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        gradientView.layer.cornerRadius = gradientView.frame.height / 2
        gradientView.layer.masksToBounds = true
        addSubview(gradientView)

        let gradient = CAGradientLayer()
        gradient.name = Shimmer.name
        gradient.frame = CGRect(
            x: 0,
            y: 0,
            width: gradientView.frame.width * 3,
            height: gradientView.frame.height)

        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.locations = [0.0, 0.5, 1.0]
        gradient.colors = [alphaColor, color.cgColor, alphaColor]

        gradientView.layer.insertSublayer(gradient, at: 0)

        // animation
        let animation = CABasicAnimation(keyPath: "locations")
        animation.duration = 1.25
        animation.repeatCount = .infinity
        animation.autoreverses = false
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]

        gradient.add(animation, forKey: nil)

        // спрячем плейсхолдерный текст
        if let label = self as? UILabel { label.text = " " }
    }

    func removeShimmerPlaceholder() {
        subviews.forEach { view in
            guard view.layer.sublayers?.first(where: { $0.name == Shimmer.name }) != nil else { return }
            view.removeFromSuperview()
        }
    }

    func gradient(
        colors: [CGColor],
        startPoint: CGPoint = CGPoint(x: 0, y: 0),
        endPoint: CGPoint = CGPoint(x: 0, y: 1),
        name: String = "default"
    ) {
        if let sublayers = layer.sublayers {
            if sublayers.contains(where: { $0 is CAGradientLayer && $0.name == name }) {
                return
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
