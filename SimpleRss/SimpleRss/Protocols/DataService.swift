//
//  DataService.swift
//  SimpleRss
//
//  Created by Voldem on 6/19/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation
import RxSwift

protocol DataService {
    
    func getTopics() -> Single<[TopicModel]>
    func getFeed(by feedUrl: String) -> Maybe<[FeedModel]>
    func saveFeed(feedList: [FeedModel], for url: String)
}
