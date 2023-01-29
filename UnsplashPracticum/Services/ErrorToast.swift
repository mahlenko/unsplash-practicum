//
// Created by Сергей Махленко on 14.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation
import Drops

enum ErrorToast {
    static func show(message: String) {
        Drops.show(Drop(title: "Oops!", subtitle: message, position: .top, duration: .seconds(4)))
        print(message)
    }
}
