//
// Created by Сергей Махленко on 14.01.2023.
// Copyright (c) 2023 ru.app-demo.unsplash. All rights reserved.
//

import Foundation
import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        UIApplication.shared.windows.first
    }

    static func show(blocked: Bool = true) {
        window?.isUserInteractionEnabled = !blocked
        ProgressHUD.show()
    }

    static func dismiss(unblocked: Bool = true) {
        window?.isUserInteractionEnabled = unblocked
        ProgressHUD.dismiss()
    }
}
