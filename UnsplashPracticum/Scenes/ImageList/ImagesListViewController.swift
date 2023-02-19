//
//  ImagesListViewController.swift
//  UnsplashPracticum
//
//  Created by Сергей Махленко on 17.10.2022.
//

import UIKit
import Kingfisher

// MARK: - ViewController

final class ImagesListViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    @IBOutlet private weak var imageFeedTable: UITableView!

    private let showSingleImageSegueId = "ShowSingleImage"

    private let notificationCenter: NotificationCenter = .default
    private var imagesListObserver: NSObjectProtocol?
    private var photoService = PhotoService.shared
    private let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        imageFeedTable.dataSource = self
        imageFeedTable.delegate = self
        imageFeedTable.backgroundColor = .backgroundBrand

        fetchPhotos()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeImagesListChanges()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObservingImagesListChanges()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        // просмотр фото
        case showSingleImageSegueId:
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else { return }

            let photo = photoService.photos[indexPath.row]
            viewController.picture = SingleImageViewModel(url: photo.largeImageURL, size: photo.size)
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController {
    private func observeImagesListChanges() {
        imagesListObserver = notificationCenter.addObserver(
            forName: PhotoService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateTableViewAnimated()
        }
    }

    private func stopObservingImagesListChanges() {
        if let imagesListObserver {
            notificationCenter.removeObserver(imagesListObserver)
        }
    }

    private func updateTableViewAnimated() {
        let countRows = imageFeedTable.numberOfRows(inSection: 0)
        let photoCount = photoService.photos.count

        if countRows < photoCount {
            let newIndexPath = (countRows ..< photoCount).map {
                IndexPath(row: $0, section: 0)
            }

            imageFeedTable.performBatchUpdates {
                imageFeedTable.insertRows(at: newIndexPath, with: .automatic)
            }
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueId, sender: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photoService.photos.count {
            fetchPhotos()
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photoService.photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImagesListCell else {
            return ImagesListCell(style: .default, reuseIdentifier: ImagesListCell.reuseIdentifier)
        }

        updateRow(for: imageListCell, with: indexPath)
        imageListCell.delegate = self

        return imageListCell
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func didTapLike(_ cell: ImagesListCell) {
        guard let indexPath = imageFeedTable.indexPath(for: cell) else { return }

        let picture = photoService.photos[indexPath.row]
        LikeRequest().sendChangeLike(id: picture.id, currentStatus: picture.isLiked) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let liked):
                self.photoService.photos[indexPath.row].updateLike(like: liked)
                self.setImageLikeButton(selected: liked, cell: cell)
            case .failure(let error):
                ErrorToast.show(message: error.localizedDescription)
            }
        }
    }

    func setImageLikeButton(selected: Bool, cell: ImagesListCell) {
        selected ? like(cell.likeButton) : dislike(cell.likeButton)
    }
}

extension ImagesListViewController {
    func fetchPhotos() {
        photoService.fetchPhotoNextPage { result in
            if case .failure(let error) = result {
                ErrorToast.show(message: error.localizedDescription)
            }
        }
    }

    func updateRow(for cell: ImagesListCell, with indexPath: IndexPath) {
        let picture = photoService.photos[indexPath.row]

        if let url = URL(string: picture.thumbImageURL) {
            let cache = ImageCache.default
            cache.memoryStorage.config.expiration = .seconds(60 * 20)

            cell.imageCell.kf.indicatorType = .activity
            cell.imageCell.kf.setImage(
                with: url,
                placeholder: UIImage(
                    blurHash: picture.blurHash,
                    size: CGSize(width: 32, height: 150)
                )
            ) { [weak self] _ in
                guard let self = self else { return }
                self.imageFeedTable.reloadRows(at: [indexPath], with: .automatic)
            }
        }

        cell.dateLabel.text = dateFormatter().string(from: picture.createdAt!)

        picture.isLiked ? like(cell.likeButton) : dislike(cell.likeButton)
    }

    func like(_ button: UIButton) {
        button.setImage(UIImage(named: "heart-active"), for: .normal)
    }

    func dislike(_ button: UIButton) {
        button.setImage(UIImage(named: "heart-default"), for: .normal)
    }
}
