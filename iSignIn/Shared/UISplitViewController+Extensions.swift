//
//  UISplitViewController+Extensions.swift
//  iSignIn
//
//  Created by Dmitrij on 2022-12-26.
//

import Foundation
import UIKit

extension UISplitViewController {
    var primaryViewController: UIViewController? {
        return self.viewControllers.first
    }

    var secondaryViewController: UIViewController? {
        return self.viewControllers.count > 1 ? self.viewControllers[1] : nil
    }
}
