//
//  RatingViewModel.swift
//  SimpleRss
//
//  Created by Voldem on 11/9/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

protocol RatingViewModelDelegeate: class {
    func dismiss()
}

protocol RatingViewModel {
    var rating: BehaviorRelay<Double> { get }
    var comment: BehaviorRelay<String> { get }
    
    var sendRating: PublishRelay<Void> { get }
}

public class RatingViewModelImplementation: RatingViewModel {
    
    let rating: BehaviorRelay<Double>
    var comment: BehaviorRelay<String>
    let sendRating = PublishRelay<Void>()
     
    private let id: String
    
    private let rssDataService: DataService
    private let disposeBag = DisposeBag()
    
    private weak var coordinator: RatingViewModelDelegeate?

    init(feed: FeedItemViewModel,
         rssDataService: DataService,
         coordinator: RatingViewModelDelegeate
    ) {
        self.rating = feed.rating
        self.id = feed.guid
        self.rssDataService = rssDataService
        self.coordinator = coordinator
        //TODO add comment field in db
        self.comment = BehaviorRelay(value: "asd")
        
        setBinding()
    }
}

extension RatingViewModelImplementation {
    
    func setBinding() {
        sendRating
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.rssDataService.updateRating(feedId: self.id, rating: self.rating.value)
                self.coordinator?.dismiss()
            }
        .disposed(by: disposeBag)
    }
}
