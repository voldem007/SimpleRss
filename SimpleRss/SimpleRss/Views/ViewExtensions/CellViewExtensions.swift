//
//  CellViewExtensions.swift
//  SimpleRss
//
//  Created by Voldem on 11/22/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

extension UIImageView {
    
    static var urlToImagePlaceholder: URL {
        return URL(string: "https://aliceasmartialarts.com/wp-content/uploads/2017/04/default-image.jpg")!
    }
}

extension UIViewController {
    
    /// Loads a controller from a storyboard based on it's inferred class name.
    /// Example: `LoginViewController` will load `Login.storyboard` by dropping the `ViewController` suffix.
    ///
    /// - Returns: A newly instantiated view controller
    public static func instantiateFromStoryboard<T: UIViewController>() -> T {
        let storyboard = UIStoryboard(viewControllerType: T.self)
        let controller = storyboard.instantiateInitialViewController() as! T
        
        return controller
    }
    
    /// Loads a controller from a storyboard based on a specified class name
    /// Example: `LoginViewController` will load `Login.storyboard` by dropping the `ViewController` suffix.
    ///
    /// - Returns: A newly instantiated view controller
    public static func instantiateFromStoryboard<T: UIViewController>(_ controllerType: T.Type) -> T {
        return instantiateFromStoryboard()
    }
}

extension UIStoryboard {
    
    /// Loads a storyboard from a controller's class name.
    /// Example: `LoginViewController.self` passed as the controllerType would load the storyboard file named `Login.storyboard`
    ///
    /// - Parameter viewControllerType: The controller type in which to load the storyboard from.
    public convenience init<T: UIViewController>(viewControllerType controllerType: T.Type) {
        var name = String(describing: T.self)
        
        if let range = name.range(of: "ViewController") {
            name = String(name[..<range.lowerBound])
        }
        
        self.init(name: name, bundle: Bundle(for: T.self))
    }
}

extension UIView {
    
    func zoomingBoundAnimate() {
        self.transform =
            CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        
        let animator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.5 ) {
            self.transform =
                CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        }
        
        animator.startAnimation()
    }
}

extension UIStackView {
    
    func removeAll() {
        for view in self.arrangedSubviews {
            view.removeFromSuperview()
        }
    }
}
