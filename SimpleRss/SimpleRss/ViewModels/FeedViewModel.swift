//
//  FeedViewModel.swift
//  SimpleRss
//
//  Created by Voldem on 6/17/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation

class FeedViewModel {
    
    private let rssDataService: DataService
    private let rssService: NetworkService
    private let url: String
    
    var onFeedChanged: (() -> Void)?
    var loadChanged: ((Bool) -> Void)?
    
    var feedList = [FeedItemViewModel]()
    
    init(rssDataService: DataService, rssService: NetworkService, url: String) {
        self.rssDataService = rssDataService
        self.rssService = rssService
        self.url = url
    }
    
    func getNetworkData() {
        loadChanged?(true)
        rssService.getFeed(for: url) { [weak self] (result, error) in
            guard let self = self, let feedList = result else { return }
            
            self.feedList = feedList.map { feed in FeedItemViewModel(feed) }
            self.rssDataService.saveFeed(feedList: feedList, for: self.url)
            
            self.onFeedChanged?()
            self.loadChanged?(false)
        }
    }
    
    func getLocalData() {
        rssDataService.getFeed(by: url) { [weak self] _feedModels in
            guard let self = self else { return }
            if let feedModels = _feedModels, !feedModels.isEmpty {
                self.feedList = feedModels.map { feed in FeedItemViewModel(feed) }
                self.onFeedChanged?()
            } else {
                self.getNetworkData()
            }
        }
    }
}
