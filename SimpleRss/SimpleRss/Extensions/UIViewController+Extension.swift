//
//  UIViewController+Extension.swift
//  SimpleRss
//
//  Created by Voldem on 12/26/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation

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
