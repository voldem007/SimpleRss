//
//  Coordinators.swift
//  SimpleRss
//
//  Created by Voldem on 6/17/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation

protocol Coordinator {
    func start()
}

protocol NavigationCoordinator: Coordinator {    
    var navigationController: UINavigationController { get }
}
