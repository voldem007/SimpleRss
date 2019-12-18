//
//  Feed.swift
//  SimpleRss
//
//  Created by Voldem on 11/22/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import Foundation

struct FeedModel {
    var guid = UUID().uuidString
    var title: String?
    var pubDate: String?
    var picLinks: [String] = []
    var description: String?
    var rating: Double?
}
