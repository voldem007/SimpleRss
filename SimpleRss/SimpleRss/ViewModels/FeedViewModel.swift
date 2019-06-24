//
//  FeedViewModel.swift
//  SimpleRss
//
//  Created by Voldem on 6/17/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation

protocol FeedViewModel: LoadingStateReportable {
    
    var content: [FeedItemViewModel] { get }
    
    func getNetworkData()
    func getLocalData()
}

class FeedViewModelImplementation {
    
    private let rssDataService: DataService
    private let rssService: NetworkService
    private let url: String
    
    var onStateChanged: ((LoadingState) -> Void)?
    
    private(set) var content = [FeedItemViewModel]()
    
    init(rssDataService: DataService, rssService: NetworkService, url: String) {
        self.rssDataService = rssDataService
        self.rssService = rssService
        self.url = url
    }
}

extension FeedViewModelImplementation: FeedViewModel {
    
    func getNetworkData() {
        reportState(.inProgress)
        rssService.getFeed(for: url) { [weak self] (result, error) in
            guard let self = self, let feedList = result else { return }
            if error != nil {
                self.reportState(.failed(error))
                return
            }
            self.content = feedList.map { feed in FeedItemViewModel(feed) }
            self.rssDataService.saveFeed(feedList: feedList, for: self.url)
            
            self.reportState(.loaded)
        }
    }
    
    func getLocalData() {
        reportState(.inProgress)
        rssDataService.getFeed(by: url) { [weak self] _feedModels in
            guard let self = self else { return }
            if let feedModels = _feedModels, !feedModels.isEmpty {
                self.content = feedModels.map { feed in FeedItemViewModel(feed) }
                self.reportState(.loaded)
            } else {
                self.getNetworkData()
            }
        }
    }
}

extension LoadingStateReportable {
    
    func reportState(_ state: LoadingState) {
        DispatchQueue.main.async { [weak self] in
            guard let stateChanged = self?.onStateChanged else { return }
            stateChanged(state)
        }
    }
}
