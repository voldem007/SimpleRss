//
//  FeedViewModel.swift
//  SimpleRss
//
//  Created by Voldem on 6/17/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

protocol FeedViewModel: ViewModel {
    
    var content: BehaviorRelay<[FeedItemViewModel]> { get }
    
    func getNetworkData()
    func getLocalData()
}

class FeedViewModelImplementation {
    
    private let rssDataService: DataService
    private let rssService: NetworkService
    private let url: String
        
    private(set) var content = BehaviorRelay<[FeedItemViewModel]>(value: [])
    private(set) var isBusy = BehaviorRelay<Bool>(value: false)
    
    init(rssDataService: DataService, rssService: NetworkService, url: String) {
        self.rssDataService = rssDataService
        self.rssService = rssService
        self.url = url
        
        getLocalData()
    }
}

extension FeedViewModelImplementation: FeedViewModel {
    
    func getNetworkData() {
        isBusy.accept(true)
        rssService.getFeed(for: url) { [weak self] (result, error) in
            guard let self = self, let feedList = result else { return }
            if error != nil {
                return
            }
            self.content.accept(feedList.map { feed in FeedItemViewModel(feed) })
            self.rssDataService.saveFeed(feedList: feedList, for: self.url)
            self.isBusy.accept(false)
        }
    }
    
    func getLocalData() {
        self.isBusy.accept(true)
        rssDataService.getFeed(by: url) { [weak self] _feedModels in
            guard let self = self else { return }
            if let feedModels = _feedModels, !feedModels.isEmpty {
                self.content.accept(feedModels.map { feed in FeedItemViewModel(feed) })
                self.isBusy.accept(false)
            } else {
                self.getNetworkData()
            }
        }
    }
}
