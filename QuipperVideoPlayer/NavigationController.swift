//
//  NavigationController.swift
//  QuipperVideoPlayer
//
//  Created by Ahmed Ali on 2019/09/01.
//  Copyright © 2019 Ahmed Ali. All rights reserved.
//

import UIKit

/// A UINavigationController subclass that propagate's
/// its topViewControllers' `supportedInterfaceOrientations`.
/// - Note: If `topViewController` is nil `UIInterfaceOrientationMask.all` will be returned.
class NavigationController: UINavigationController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        guard let vc = topViewController else {
            return .all
        }
        return vc.supportedInterfaceOrientations
    }
}
