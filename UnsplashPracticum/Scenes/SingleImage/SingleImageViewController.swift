//
// Created by Сергей Махленко on 30.11.2022.
// Copyright (c) 2022 ru.app-demo.unsplash. All rights reserved.
//

import UIKit
import Kingfisher
import Drops

final class SingleImageViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    // MARK: - Outlets

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var sharingButton: UIButton!

    var picture: SingleImageViewModel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(_: animated)
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        displayImage()
    }

    private func displayImage() {
        UIBlockingProgressHUD.show(blocked: false)
        guard let imageURL = URL(string: picture.url) else { return }

        imageView.kf.setImage(with: imageURL) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }

                UIBlockingProgressHUD.dismiss(unblocked: true)

                switch result {
                case .success(let imageResult):
                    self.rescaleAndCenterImageInScrollView(contentSize: imageResult.image.size)
                case .failure(let error):
                    if !error.isTaskCancelled {
                        ErrorToast.show(message: "Не удалось загрузить изображение.", action: .init(
                            icon: UIImage(systemName: "repeat")
                        ) { [weak self] in
                            guard let self = self else {
                                return
                            }
                            self.displayImage()
                            Drops.hideCurrent()
                        })
                    }
                }
            }
        }
    }

    // MARK: - Actions

    @IBAction private func didTapBackButton() {
        imageView.kf.cancelDownloadTask()
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func didTapShareButton(_ sender: Any) {
        guard let image = imageView.image else { return }
        let imageToShared = [image as UIImage] as [Any]

        let activityViewController = UIActivityViewController(
            activityItems: imageToShared,
            applicationActivities: nil)

        present(activityViewController, animated: true)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

extension SingleImageViewController {
    private func rescaleAndCenterImageInScrollView(contentSize: CGSize) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale

        view.layoutIfNeeded()

        let visibleRectSize = scrollView.bounds.size
        let hScale = visibleRectSize.width / contentSize.width
        let vScale = visibleRectSize.height / contentSize.height

        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))

        scrollView.setZoomScale(scale, animated: false)

        scrollView.layoutIfNeeded()

        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}
