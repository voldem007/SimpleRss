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
    
    let content: Observable<[FeedItemViewModel]>
    let selectedFeed = PublishRelay<FeedItemViewModel>()
    let isBusy: Observable<Bool>
    let updateFeed = PublishRelay<Void>()
    
    init(rssDataService: DataService, rssService: NetworkService, url: String) {
        let selected = selectedFeed.asObservable()
        
        let refresh = updateFeed
            .flatMap { _ in rssService.getFeed(for: URL(string: url)!).catchErrorJustReturn([FeedModel]()) }
            .do(onNext: {
                guard !$0.isEmpty else { return }
                rssDataService.saveFeed(feedList: $0, for: url)
            })
        
        content = rssDataService.getFeed(by: url)
            .asObservable()
            .concat(refresh)
            .materialize()
            .map { $0.element?.map { feedItem in FeedItemViewModel(feedItem, selected) } ?? [FeedItemViewModel]() }
            .share(replay: 1, scope: .whileConnected)
        
        isBusy = content.map { _ in false }
    }
}
