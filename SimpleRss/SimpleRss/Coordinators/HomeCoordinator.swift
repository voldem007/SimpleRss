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
    private lazy var rssDataService: DataService = RssDataService()
    private lazy var rssService: NetworkService = RssNetworkService()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let home = HomeViewController(viewModel: HomeViewModelImplementation(rssDataService: rssDataService, delegate: self))
        navigationController.pushViewController(home, animated: true)
    }
    
    private func showFeed(url: String) {
        navigationController.pushViewController(FeedViewController(viewModel: FeedViewModelImplementation(rssDataService: rssDataService, rssService: rssService, url: url)), animated: true)
    }
}

extension HomeCoordinator: HomeViewModelDelegeate {
    
    func userDidSelectFeed(url: String) {
        showFeed(url: url)
    }
}
