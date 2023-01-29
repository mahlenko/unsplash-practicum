//
// Created by Сергей Махленко on 14.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation
import UIKit

struct Profile {
    let firstName: String
    let lastName: String
    let username: String
    var biography: String?
    var avatar: UIImage?
    var name: String { "\(firstName) \(lastName)" }
    var loginName: String { "@\(username)" }
}
