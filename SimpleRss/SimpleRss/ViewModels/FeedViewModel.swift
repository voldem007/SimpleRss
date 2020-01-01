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

protocol FeedViewModelDelegeate: class {
    func userDidSelectFeed(_ feed: FeedItemViewModel)
}

protocol FeedViewModel: ViewModel {
    var content: Observable<[FeedItemViewModel]> { get }
    var updateFeed: PublishRelay<Void> { get }
    var selectedFeed: PublishRelay<FeedItemViewModel> { get }
}

class FeedViewModelImplementation: FeedViewModel {
    
    private let disposeBag = DisposeBag()
    private weak var coordinator: FeedViewModelDelegeate?
    
    let content: Observable<[FeedItemViewModel]>
    let selectedFeed = PublishRelay<FeedItemViewModel>()
    let isBusy: Observable<Bool>
    let updateFeed = PublishRelay<Void>()
    
    init(rssDataService: DataService,
         rssService: NetworkService,
         url: String,
         coordinator: FeedViewModelDelegeate
    ) {
        self.coordinator = coordinator
        
        let refresh = rssService.getFeed(for: URL(string: url)!).flatMap { items in
            rssDataService.saveFeed(feedList: items, for: url).flatMap { _ in
                rssDataService.getFeed(by: url).asObservable().asSingle()
            }
        }
        
        content = rssDataService.getFeed(by: url)
            .flatMap { items in
                if items.isEmpty {
                    return refresh.asMaybe()
                } else {
                    return Maybe<[FeedModel]>.just(items)
                }
            }
            .asObservable()
            .concat(updateFeed.flatMap { _ in refresh })
            .materialize()
            .map { $0.element?.map { FeedItemViewModel($0) } ?? [FeedItemViewModel]() }
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
        coordinator?.userDidSelectFeed(feed)
    }
}
