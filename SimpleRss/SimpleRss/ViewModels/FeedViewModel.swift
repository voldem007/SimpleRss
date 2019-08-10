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
    
    var content: Observable<[FeedItemViewModel]> { get }
    var updateFeed: PublishRelay<Void> { get }
    var selectedFeed: PublishRelay<FeedItemViewModel> { get }
}

class FeedViewModelImplementation: FeedViewModel {
    
    private let rssDataService: DataService
    private let rssService: NetworkService
    private let url: String
    
    private let disposeBag = DisposeBag()
    
    let content: Observable<[FeedItemViewModel]>
    let selectedFeed = PublishRelay<FeedItemViewModel>()
    let isBusy: Observable<Bool>
    let updateFeed = PublishRelay<Void>()
    
    init(rssDataService: DataService, rssService: NetworkService, url: String) {
        self.rssDataService = rssDataService
        self.rssService = rssService
        self.url = url
        
        let selected = selectedFeed.asObservable()
        
        let refresh = updateFeed
            .flatMap { _ in rssService.getFeed(for: URL(string: url)!) }
            .do(onNext: { rssDataService.saveFeed(feedList: $0, for: url) })
        
        content = rssDataService.getFeed(by: url)
            .asObservable()
            .concat(refresh)
            .map { $0.map { feedItem in FeedItemViewModel(feedItem, selected) } }
            .share(replay: 1, scope: .whileConnected)
        
        isBusy = content.map { _ in false }
    }
}
