//
//  Extensions.swift
//  Compass AI V2
//
//  Created by Steve on 8/23/25.
//
import UIKit

extension UINavigationController {
    func replaceTopViewController(with viewController: UIViewController, animated: Bool) {
        var viewControllers = self.viewControllers
        if let lastViewController = viewControllers.last {
            // Replace the last view controller with the new one
            viewControllers[viewControllers.count - 1] = viewController
            setViewControllers(viewControllers, animated: animated)
        }
    }
}
