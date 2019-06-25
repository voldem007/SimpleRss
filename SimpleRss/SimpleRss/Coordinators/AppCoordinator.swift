//
//  AppCoordinator.swift
//  SimpleRss
//
//  Created by Voldem on 6/17/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation

public class AppCoordinator: Coordinator {
    
    private let window: UIWindow?
    private let navigationController: UINavigationController
    private var childCoordinator: HomeCoordinator?
    
    init(window: UIWindow?) {
        self.window = window
        
        navigationController = UINavigationController()
        self.window?.rootViewController = navigationController
    }
    
    func start() {
        showHome()
    }
    
    private func showHome() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        childCoordinator = homeCoordinator
        homeCoordinator.start()
    }
}
