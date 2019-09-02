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
    let isExpanded: BehaviorRelay<Bool>
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
        isExpanded = BehaviorRelay(value: false)
    }
}

extension FeedItemViewModel: Equatable {
    
    static func == (lhs: FeedItemViewModel, rhs: FeedItemViewModel) -> Bool {
        return lhs.guid == rhs.guid
    }
}
