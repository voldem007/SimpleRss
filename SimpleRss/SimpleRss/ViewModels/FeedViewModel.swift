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
import RxCocoa

protocol FeedViewModel: ViewModel {
    
    var content: BehaviorRelay<[FeedItemViewModel]> { get }
    var updateFeed: PublishRelay<Bool> { get }
    var selectedFeed: PublishRelay<FeedItemViewModel> { get }
}

class FeedViewModelImplementation {
    
    private let rssDataService: DataService
    private let rssService: NetworkService
    private let url: String
    
    private let disposeBag = DisposeBag()
    
    let content = BehaviorRelay<[FeedItemViewModel]>(value: [])
    let selectedFeed = PublishRelay<FeedItemViewModel>()
    private(set) var isBusy = BehaviorRelay<Bool>(value: false)
    let updateFeed = PublishRelay<Bool>()
    
    init(rssDataService: DataService, rssService: NetworkService, url: String) {
        self.rssDataService = rssDataService
        self.rssService = rssService
        self.url = url
        
        setBinding()
        getLocalData()
    }
}

extension FeedViewModelImplementation: FeedViewModel {
    
    func setBinding() {
        updateFeed.subscribe { [weak self] event in
            guard let self = self else { return }
            self.getNetworkData()
            }
            .disposed(by: disposeBag)
    }
    
    func getNetworkData() {
        isBusy.accept(true)
        rssService.getFeed(for: self.url) { [weak self] (result, error) in
            guard let self = self, let feedList = result else { return }
            if error != nil {
                return
            }
            self.content.accept(feedList.map { feed in
                let feedVM = FeedItemViewModel(feed)
                
                self.selectedFeed
                    .filter {
                        $0 == feedVM
                    }
                    .map { _ in Void() }
                    .bind(to: feedVM.toggle)
                    .disposed(by: self.disposeBag)
                return feedVM
            })
            self.rssDataService.saveFeed(feedList: feedList, for: self.url)
            self.isBusy.accept(false)
        }
    }
    
    func getLocalData() {
        self.isBusy.accept(true)
        self.rssDataService.getFeed(by: self.url) { [weak self] _feedModels in
            guard let self = self else { return }
            if let feedModels = _feedModels, !feedModels.isEmpty {
                self.content.accept(feedModels.map { feed in
                    let feedVM = FeedItemViewModel(feed)
                    
                    self.selectedFeed
                        .filter {
                            $0 == feedVM
                        }
                        .map { _ in Void() }
                        .bind(to: feedVM.toggle)
                        .disposed(by: self.disposeBag)
                    return feedVM
                    
                })
                self.isBusy.accept(false)
            } else {
                self.getNetworkData()
            }
        }
    }
}
