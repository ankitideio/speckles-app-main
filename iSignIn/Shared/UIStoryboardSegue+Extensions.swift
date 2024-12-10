//
//  UIStoryboardSegue+Extensions.swift
//  iSignIn
//
//  Created by Dmitrij on 2022-12-28.
//

import Foundation
import UIKit

extension UIStoryboardSegue {
    func topLevelDestinationViewController() -> UIViewController {
        var dest = destination
        if let nav = dest as? UINavigationController, let topVc = nav.topViewController {
            dest = topVc
        }
        return dest
    }
}
