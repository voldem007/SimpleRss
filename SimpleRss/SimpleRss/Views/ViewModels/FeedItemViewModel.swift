//
//  FeedItemViewModel.swift
//  SimpleRss
//
//  Created by Voldem on 12/3/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class FeedItemViewModel {
    
    let guid: String
    let title: BehaviorRelay<String>
    //let isExpanded: Observable<Bool>
    let pubDate: BehaviorRelay<String>
    let description: BehaviorRelay<String>
    let picUrls: BehaviorRelay<[URL]>
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(_ feedModel: FeedModel) {
        guid = feedModel.guid
        title = BehaviorRelay(value: feedModel.title ?? "")
        pubDate = BehaviorRelay(value: feedModel.pubDate ?? "")
        description = BehaviorRelay(value: feedModel.description ?? "")
        picUrls = BehaviorRelay(value: feedModel.picLinks.map { URL(string: $0)! })
        
        var expanded = false
//        isExpanded = selectedFeed
//            .filter { $0.guid == feedModel.guid }
//            .do(onNext: { _ in expanded.toggle() })
//            .map { _ in expanded }
//            .share(replay: 1, scope: .forever)
    }
}

extension FeedItemViewModel: Equatable {
    
    static func == (lhs: FeedItemViewModel, rhs: FeedItemViewModel) -> Bool {
        return lhs.guid == rhs.guid
    }
}
