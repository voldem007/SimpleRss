//
//  Feed.swift
//  SimpleRss
//
//  Created by Voldem on 11/22/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import Foundation

class Feed {
    var isExpanded: Bool
    var title: String
    var pubDate: String
    var picUrl: String
    var description: String
    
    init(isExpanded: Bool, title: String, pubDate: String, picUrl: String, description: String) {
        self.isExpanded = isExpanded
        self.title = title
        self.pubDate = pubDate
        self.picUrl = picUrl
        self.description = description
    }
}
