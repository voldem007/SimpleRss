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
        let home = HomeViewController(viewModel: HomeViewModelImplementation(rssDataService: rssDataService,
                                                                             coordinator: self))
        navigationController.pushViewController(home, animated: true)
    }
    
    private func showFeed(url: String) {
        navigationController.pushViewController(FeedViewController(viewModel: FeedViewModelImplementation(rssDataService: rssDataService, rssService: rssService, url: url, coordinator: self)), animated: true)
    }
    
    private func showDetail(_ feed: FeedItemViewModel) {
        let controller: FeedDetailViewController = .instantiateFromStoryboard()
        controller.viewModel = FeedDetailViewModelImplementation(feed: feed, coordinator: self)
        navigationController.pushViewController(controller, animated: true)
    }
    
    private func showRating(_ feed: FeedItemViewModel) {
        let controller: RatingViewController = .instantiateFromStoryboard()
        controller.viewModel = RatingViewModelImplementation(feed: feed,
                                                             rssDataService: rssDataService,
                                                             coordinator: self)
        controller.modalPresentationStyle = .custom
        navigationController.present(controller, animated: true)
    }
}

extension HomeCoordinator: HomeViewModelDelegeate {
    
    func userDidSelectTopic(url: String) {
        showFeed(url: url)
    }
}

extension HomeCoordinator: FeedViewModelDelegeate {
    
    func userDidSelectFeed(_ feed: FeedItemViewModel) {
        showDetail(feed)
    }
}

extension HomeCoordinator: FeedDetailViewModelDelegeate {
    
    func requestRating(_ feed: FeedItemViewModel) {
        showRating(feed)
    }
}

extension HomeCoordinator: RatingViewModelDelegeate {
    
    func dismiss() {
        navigationController.dismiss(animated: true)
    }
}
