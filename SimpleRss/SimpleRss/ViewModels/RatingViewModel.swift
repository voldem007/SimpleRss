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

protocol RatingViewModel {
    var rating: BehaviorRelay<Double> { get }
    var comment: BehaviorRelay<String> { get }
}

public class RatingViewModelImplementation: RatingViewModel {
    
    let rating: BehaviorRelay<Double>
    var comment: BehaviorRelay<String>

    init(feed: FeedItemViewModel) {
        self.rating = feed.rating
        //TODO add comment field in db
        self.comment = BehaviorRelay(value: "asd")
    }
}
