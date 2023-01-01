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
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageFillScreen(image: image)
        imageCentered()
    }

    func imageFillScreen(image: UIImage) {
        let visibleRectSize = scrollView.bounds.size
        let imageSize = imageView.bounds.size

        let scale = min(
            maxScale,
            max(
                scrollView.minimumZoomScale,
                max(visibleRectSize.width / imageSize.width, visibleRectSize.height / imageSize.height)
            ))

        view.layoutIfNeeded()
        scrollView.setZoomScale(scale, animated: true)
    }

    func imageCentered() {
        let scrollSize = scrollView.bounds.size
        var imageFrame = imageView.frame ?? CGRect.zero

        if imageFrame.size.width < scrollSize.width {
            imageFrame.origin.x = (scrollSize.width - imageFrame.size.width) * 0.5
        } else {
            imageFrame.origin.x = 0.0
        }

        if imageFrame.size.height < scrollSize.height {
            imageFrame.origin.y = (scrollSize.height - imageFrame.size.height) * 0.5
        } else {
            imageFrame.origin.y = 0.0
        }

        imageView.frame = imageFrame
    }

//    private func rescaleAndCenterImageInScrollView(image: UIImage) {
//        let minZoomScale = scrollView.minimumZoomScale
//        let maxZoomScale = scrollView.maximumZoomScale
//
//        view.layoutIfNeeded()
//        let visibleRectSize = scrollView.bounds.size
//        let imageSize = image.size
//        let hScale = visibleRectSize.width / imageSize.width
//        let vScale = visibleRectSize.height / imageSize.height
//        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
//        scrollView.setZoomScale(scale, animated: false)
//
//        scrollView.layoutIfNeeded()
//        let newContentSize = scrollView.contentSize
//        let x = (newContentSize.width - visibleRectSize.width) / 2
//        let y = (newContentSize.height - visibleRectSize.height) / 2
//        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
//    }
}

extension SingleImageViewController: UIScrollViewDelegate {
//    open override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        imageCentered()
//    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        imageCentered()
    }
}
