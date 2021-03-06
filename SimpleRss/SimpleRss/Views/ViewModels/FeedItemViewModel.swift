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
    
    let id: String
    let title: BehaviorRelay<String>
    let isExpanded: BehaviorRelay<Bool>
    let pubDate: BehaviorRelay<String>
    let description: BehaviorRelay<String>
    let picUrls: BehaviorRelay<[URL]>
    let rating: BehaviorRelay<Double>
    let comment: BehaviorRelay<String>
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(_ feedModel: FeedModel) {
        id = feedModel.id
        title = BehaviorRelay(value: feedModel.title ?? "")
        pubDate = BehaviorRelay(value: feedModel.pubDate ?? "")
        description = BehaviorRelay(value: feedModel.description ?? "")
        picUrls = BehaviorRelay(value: feedModel.picLinks.compactMap { $0.isEmpty ? UIImageView.urlToImagePlaceholder : URL(string: $0)! })
        isExpanded = BehaviorRelay(value: false)
        rating = BehaviorRelay(value: feedModel.rating ?? 0.0)
        comment = BehaviorRelay(value: feedModel.comment ?? "")
    }
}

extension FeedItemViewModel: Equatable {
    
    static func == (lhs: FeedItemViewModel, rhs: FeedItemViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
