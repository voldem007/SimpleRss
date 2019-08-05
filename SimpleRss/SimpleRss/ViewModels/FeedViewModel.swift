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
    
    var content: Observable<[FeedItemViewModel]>? { get }
    var updateFeed: PublishRelay<Void> { get }
    var selectedFeed: PublishRelay<FeedItemViewModel> { get }
}

class FeedViewModelImplementation {
    
    private let rssDataService: DataService
    private let rssService: NetworkService
    private let url: String
    
    private let disposeBag = DisposeBag()
    
    private(set) var content: Observable<[FeedItemViewModel]>?
    let selectedFeed = PublishRelay<FeedItemViewModel>()
    private(set) var isBusy: Observable<Bool>?
    let updateFeed = PublishRelay<Void>()
    
    init(rssDataService: DataService, rssService: NetworkService, url: String) {
        self.rssDataService = rssDataService
        self.rssService = rssService
        self.url = url

        let refresh = updateFeed.flatMap { _ in rssService.getFeed(for: URL(string: self.url)!) }.do(onNext: { [weak self] feedModels in
            guard let self = self else { return }
            self.rssDataService.saveFeed(feedList: feedModels, for: self.url)
        })
        
        self.content = self.rssDataService.getFeed(by: self.url).asObservable().concat(refresh).map { feed in
            feed.map { feedItem in FeedItemViewModel(feedItem, self.selectedFeed) }
        }
        
        self.isBusy = self.content?.map { _ in false }
    }
}

extension FeedViewModelImplementation: FeedViewModel {
    
    func getNetworkData() -> Observable<[FeedItemViewModel]> {
        return Observable.create { observer in
            let url = URL(string: self.url)!
            let sub = self.rssService.getFeed(for: url).subscribe(onSuccess: { [weak self] feedModels in
                guard let self = self else { return }
                observer.onNext(feedModels.map { feed in FeedItemViewModel(feed, self.selectedFeed) })
                self.rssDataService.saveFeed(feedList: feedModels, for: self.url)
                }, onError: nil
            )
            return sub
        }
    }
    
    func getLocalData() -> Observable<[FeedItemViewModel]> {
        return Observable.create { observer in
            let sub = self.rssDataService.getFeed(by: self.url).subscribe(onSuccess: { [weak self] feedModels in
                guard let self = self else { return }
                observer.onNext(feedModels.map { feed in FeedItemViewModel(feed, self.selectedFeed) })
                }, onError: nil,
                   onCompleted: { [weak self] in
                    observer.onCompleted()
                    //self?.getNetworkData()
                }
            )
            return sub
        }
    }
}
