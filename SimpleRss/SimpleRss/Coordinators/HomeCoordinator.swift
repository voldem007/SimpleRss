//
//  HomeCoordinator.swift
//  SimpleRss
//
//  Created by Voldem on 6/17/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation

final class HomeCoordinator: NavigationCoordinator {
    
    internal var navigationController: UINavigationController
    private lazy var dataService = DataService()
    private lazy var rssService = RssService()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let home = HomeViewController(viewModel: HomeViewModel(dataService: dataService), delegate: self)
        navigationController.pushViewController(home, animated: true)
    }
    
    private func showFeed(url: String) {
        navigationController.pushViewController(FeedViewController(viewModel: FeedViewModel(dataService: dataService, rssService: rssService, url: url)), animated: true)
    }
}

extension HomeCoordinator: HomeViewControllerDelegeate {
    
    func userDidSelectFeed(url: String) {
        showFeed(url: url)
    }
}
