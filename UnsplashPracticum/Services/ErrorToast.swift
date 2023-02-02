//
// Created by Сергей Махленко on 14.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation
import UIKit
import Drops

enum ErrorToast {
    static func show(message: String, title: String = "Что-то пошло не так", action: Drop.Action? = nil) {
        Drops.show(
            Drop(
                title: title,
                subtitle: message,
                action: action,
                position: .top,
                duration: .seconds(8),
                accessibility: "Alert: Title, Subtitle"
            )
        )
    }
}
