//
// Created by Сергей Махленко on 30.11.2022.
// Copyright (c) 2022 ru.app-demo.unsplash. All rights reserved.
//

import UIKit

class SingleImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!

    let maxScale = 1.25

    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
        }
    }

    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image

        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = maxScale

        // размеры и позиционирование изображения
        scrollView.setZoomScale(getScaleImage(), animated: false)
        centeredImage()
    }

    private func centeredImage() {
        print("↔️↕️Centering the image on the screen...")

        scrollView.layoutIfNeeded()

        let viewSize = scrollView.bounds.size
        let contentSize = scrollView.contentSize

        let offset = (
            left: Double((contentSize.width - viewSize.width) / 2),
            top: Double((contentSize.height - viewSize.height) / 2))

        scrollView.setContentOffset(
                CGPoint(
                    x: offset.left,
                    y: offset.top),
                animated: false)

        print("Offsets: \(offset)")
    }

    /// Вернет масштаб изображения
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
}

extension SingleImageViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
