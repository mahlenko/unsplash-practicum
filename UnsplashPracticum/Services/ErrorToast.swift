//
// Created by Сергей Махленко on 14.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation
import Drops

enum ErrorToast {
    static func show(message: String, title: String = "Что-то пошло не так") {
        Drops.show(Drop(title: title, subtitle: message, position: .top, duration: .seconds(4)))
    }
}
