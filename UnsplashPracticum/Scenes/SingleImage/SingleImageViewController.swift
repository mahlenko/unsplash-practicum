//
// Created by Сергей Махленко on 30.11.2022.
// Copyright (c) 2022 ru.app-demo.unsplash. All rights reserved.
//

import UIKit

final class SingleImageViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    // MARK: - Outlets

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var sharingButton: UIButton!

    // MARK: -
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25

        imageView.image = image

        // размеры и позиционирование изображения
        scrollView.setZoomScale(getScaleImage(), animated: false)
        centeredImage()
    }

    private func getScaleImage() -> CGFloat {
        let minScale = scrollView.minimumZoomScale
        let maxScale = scrollView.maximumZoomScale

        let imageSize = image.size
        let viewSize = scrollView.bounds.size

        let wScale = viewSize.height / imageSize.height
        let hScale = viewSize.width / imageSize.width

        let theoreticalScale = max(hScale, wScale)

        return min(maxScale, max(minScale, theoreticalScale))
    }

    private func centeredImage() {
        scrollView.layoutIfNeeded()

        let viewSize = scrollView.bounds.size
        let contentSize = scrollView.contentSize

        let offset = (
            left: Double((contentSize.width - viewSize.width) / 2),
            top: Double((contentSize.height - viewSize.height) / 2))

        scrollView.setContentOffset(
            CGPoint(x: offset.left, y: offset.top),
            animated: false)
    }

    // MARK: - Actions

    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func didTapShareButton(_ sender: Any) {
        guard let image else { return }
        let imageToShared = [image as UIImage] as [Any]

        let activityViewController = UIActivityViewController(
            activityItems: imageToShared,
            applicationActivities: nil)

        present(activityViewController, animated: true)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
