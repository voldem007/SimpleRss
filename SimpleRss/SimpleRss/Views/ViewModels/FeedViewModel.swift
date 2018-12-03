//
//  FeedViewModel.swift
//  SimpleRss
//
//  Created by Voldem on 12/3/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import Foundation

class FeedViewModel {
    private var feedModel: Feed
    
    init(_ feedModel: Feed) {
        self.feedModel = feedModel
    }
    
    var isExpanded: Bool = false
    var title: String { get { return feedModel.title } }
    var pubDate: String { return feedModel.pubDate }
    var picUrl: String { return feedModel.picUrl }
    var description: String { return feedModel.description }
}
