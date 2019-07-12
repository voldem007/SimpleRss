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
    let isExpanded = BehaviorRelay(value: false)
    let pubDate: BehaviorRelay<String?>
    let description: BehaviorRelay<String?>
    let picUrl: BehaviorRelay<URL?>
    let toggle = PublishRelay<Void>()

    let disposeBag: DisposeBag = DisposeBag()
    
    init(_ feedModel: FeedModel) {
        guid = feedModel.guid
        title = BehaviorRelay(value: feedModel.title)
        pubDate = BehaviorRelay(value: feedModel.pubDate)
        description = BehaviorRelay(value: feedModel.description)
        picUrl = BehaviorRelay(value: URL(string: feedModel.picLink ?? ""))
        setBinding()
    }
    
    func setBinding() {
        toggle
            .subscribe { [weak self] item in
                guard let self = self else { return }
                self.isExpanded.accept(!self.isExpanded.value)
            }
            .disposed(by: disposeBag)
    }
}

extension FeedItemViewModel: Equatable {
    
    static func == (lhs: FeedItemViewModel, rhs: FeedItemViewModel) -> Bool {
        return lhs.guid == rhs.guid
    }
}
