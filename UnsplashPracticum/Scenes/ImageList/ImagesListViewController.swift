//
//  ImagesListViewController.swift
//  UnsplashPracticum
//
//  Created by Сергей Махленко on 17.10.2022.
//

import UIKit

// MARK: - ViewController

final class ImagesListViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    @IBOutlet private weak var imageFeedTable: UITableView!

    private let showSingleImageSegueId = "ShowSingleImage"

    private var photosName: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        imageFeedTable.dataSource = self
        imageFeedTable.delegate = self
        imageFeedTable.backgroundColor = .backgroundBrand

        photosName = Array(0..<20).map { "\($0)" }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case showSingleImageSegueId:
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        default:
            super.prepare(for: segue, sender: sender)
        }
    }

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueId, sender: indexPath)
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }

        let ratio = image.size.height / image.size.width
        return (view.frame.width - 32) * ratio
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImagesListCell else {
            return ImagesListCell(style: .default, reuseIdentifier: ImagesListCell.reuseIdentifier)
        }

        configCell(for: imageListCell, with: indexPath)

        return imageListCell
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return
        }

        cell.imageCell.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())

        // mock liked button
        if (indexPath.row % 2) != 0 {
            like(cell.likeButton)
        } else {
            dislike(cell.likeButton)
        }
    }

    func like(_ button: UIButton) {
        button.imageView?.image = UIImage(named: "heart-active")
    }

    func dislike(_ button: UIButton) {
        button.imageView?.image = UIImage(named: "heart-default")
    }
}
