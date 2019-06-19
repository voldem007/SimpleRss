//
//  FeedItemViewModel.swift
//  SimpleRss
//
//  Created by Voldem on 12/3/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import Foundation

class FeedItemViewModel {
    private let feedModel: FeedModel
    private var expanded: Bool = false
    
    var isExpanded: Bool { return expanded }
    var title: String? { return feedModel.title }
    var pubDate: String? { return feedModel.pubDate }
    var picUrl: String? { return feedModel.picLink }
    var description: String? { return feedModel.description }
    
    init(_ feedModel: FeedModel) {
        self.feedModel = feedModel
    }
    
    func toggle() {
        expanded = !expanded
    }
}