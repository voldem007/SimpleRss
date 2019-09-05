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

protocol FeedViewModelDelegeate: AnyObject {
    
    func userDidSelectFeed(_ feed: FeedItemViewModel)
}

protocol FeedViewModel: ViewModel {
    
    var content: Observable<[FeedItemViewModel]> { get }
    var updateFeed: PublishRelay<Void> { get }
    var selectedFeed: PublishRelay<FeedItemViewModel> { get }
}

class FeedViewModelImplementation: FeedViewModel {
    
    private let disposeBag = DisposeBag()
    private weak var delegate: FeedViewModelDelegeate?
    
    let content: Observable<[FeedItemViewModel]>
    let selectedFeed = PublishRelay<FeedItemViewModel>()
    let isBusy: Observable<Bool>
    let updateFeed = PublishRelay<Void>()
    
    init(rssDataService: DataService, rssService: NetworkService, url: String, delegate: FeedViewModelDelegeate) {
        self.delegate = delegate
        
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
            .map { $0.element?.map { feedItem in FeedItemViewModel(feedItem) } ?? [FeedItemViewModel]() }
            .share(replay: 1, scope: .whileConnected)
        
        isBusy = content.map { _ in false }
        
        setBinding()
    }
}

extension FeedViewModelImplementation {
    
    func setBinding() {
        selectedFeed
            .subscribe { [weak self] event in
                guard let self = self,
                    let feed = event.element else { return }
                self.showFeed(feed)
            }
            .disposed(by: disposeBag)
    }
    
    func showFeed(_ feed: FeedItemViewModel) {
        delegate?.userDidSelectFeed(feed)
    }
}
