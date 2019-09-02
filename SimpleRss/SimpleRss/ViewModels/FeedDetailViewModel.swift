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

protocol FeedDetailViewModel {
    
    var title: Observable<String> { get }
    var description: Observable<String> { get }
    var pubDate: Observable<String> { get }
    var picUrls: Observable<[URL]> { get }
}

public class FeedDetailViewModelImplementation: FeedDetailViewModel {
    
    let title: Observable<String>
    let description: Observable<String>
    let picUrls: Observable<[URL]>
    let pubDate: Observable<String>
    
    init(feed: FeedItemViewModel) {
        self.title = feed.title.asObservable()
        self.description = feed.description.asObservable()
        self.picUrls = feed.picUrls.asObservable()
        self.pubDate = feed.pubDate.asObservable()
    }
}
