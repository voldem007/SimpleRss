//
//  DataService.swift
//  SimpleRss
//
//  Created by Voldem on 6/19/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation

protocol DataService {
    
    func getTopics(completion: @escaping([TopicModel]?) -> Void)
    func getFeed(by feedUrl: String, completion: @escaping([FeedModel]?) -> Void)
    func saveFeed(feedList: [FeedModel], for url: String)
}
