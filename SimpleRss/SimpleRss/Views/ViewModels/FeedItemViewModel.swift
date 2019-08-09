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
    let title: BehaviorRelay<String?>
    var isExpanded: Observable<Bool>?
    let pubDate: BehaviorRelay<String?>
    let description: BehaviorRelay<String?>
    let picUrl: BehaviorRelay<URL?>
    var isOpened = false
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(_ feedModel: FeedModel, _ selectedFeed: Observable<FeedItemViewModel>) {
        guid = feedModel.guid
        title = BehaviorRelay(value: feedModel.title)
        pubDate = BehaviorRelay(value: feedModel.pubDate)
        description = BehaviorRelay(value: feedModel.description)
        picUrl = BehaviorRelay(value: URL(string: feedModel.picLink ?? ""))
        
        isExpanded = selectedFeed
            .filter { $0.guid == feedModel.guid }
            .map { [weak self] _ in return self?.toggle() ?? false }
    }
    
    private func toggle() -> Bool {
        isOpened = !isOpened
        return isOpened
    }
}

extension FeedItemViewModel: Equatable {
    
    static func == (lhs: FeedItemViewModel, rhs: FeedItemViewModel) -> Bool {
        return lhs.guid == rhs.guid
    }
}
