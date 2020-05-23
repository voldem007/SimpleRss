//
//  FeedDetailViewModel.swift
//  SimpleRss
//
//  Created by Voldem on 8/25/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

protocol FeedDetailViewModelDelegate: class {
    func requestRating(_ feed: FeedItemViewModel)
}

protocol FeedDetailViewModel {
    var title: Observable<String> { get }
    var description: Observable<String> { get }
    var pubDate: Observable<String> { get }
    var picUrls: Observable<[URL]> { get }
    var rating: Observable<Double> { get }
    
    var showRating: PublishRelay<Void> { get }
}

public class FeedDetailViewModelImplementation: FeedDetailViewModel {
    
    private weak var coordinator: FeedDetailViewModelDelegate?
    private let disposeBag = DisposeBag()
    
    let title: Observable<String>
    let description: Observable<String>
    let picUrls: Observable<[URL]>
    let pubDate: Observable<String>
    let rating: Observable<Double>
    
    let feed: FeedItemViewModel
    
    let showRating = PublishRelay<Void>()
    
    init(feed: FeedItemViewModel,
         coordinator: FeedDetailViewModelDelegate
    ) {
        self.coordinator = coordinator
        self.title = feed.title.asObservable()
        self.description = feed.description.asObservable()
        self.picUrls = feed.picUrls.asObservable()
        self.pubDate = feed.pubDate.asObservable()
        self.rating = feed.rating.asObservable()
        
        self.feed = feed
        
        setBinding()
    }
}

extension FeedDetailViewModelImplementation {
    
    func setBinding() {
        showRating
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.requestRating()
        }
        .disposed(by: disposeBag)
    }
    
    func requestRating() {
        coordinator?.requestRating(feed)
    }
}
