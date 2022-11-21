//
// Created by Сергей Махленко on 09.11.2022.
// Copyright (c) 2022 ru.app-demo.unsplash. All rights reserved.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateRowView: UIView!
    @IBOutlet weak var dateLabel: UILabel!

    // MARK: - IBOutlets
    static let reuseIdentifier = "ImageListCell"

    override func layoutSubviews() {
        super.layoutSubviews()
        configuration()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    private func configuration() {
        backgroundColor = UIColor.clear
        selectionStyle = .none

        // rounded imageViewCell
        imageCell.layer.masksToBounds = true
        imageCell.layer.cornerRadius = 16
        imageCell.layer.backgroundColor = UIColor.blueBrand.cgColor

        // rounded labelView
        dateRowView.layer.masksToBounds = imageCell.layer.masksToBounds
        dateRowView.layer.cornerRadius = imageCell.layer.cornerRadius
        dateRowView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        setGradient()
    }

    private func setGradient() {
        dateRowView.gradient(
            colors: [
                UIColor.blackBrand.withAlphaComponent(0).cgColor,
                UIColor.blackBrand.withAlphaComponent(0.2).cgColor
            ],
            startPoint: CGPoint(x: 0, y: 0),
            endPoint: CGPoint(x: 0, y: 0.53))
    }
}
