//
// Created by Сергей Махленко on 30.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func didTapLike(_ cell: ImagesListCell)
}
