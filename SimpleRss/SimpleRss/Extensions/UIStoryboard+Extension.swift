//
//  UIStoryboard+Extension.swift
//  SimpleRss
//
//  Created by Voldem on 12/26/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

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
