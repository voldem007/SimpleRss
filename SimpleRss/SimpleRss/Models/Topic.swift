//
//  Topic.swift
//  SimpleRss
//
//  Created by Voldem on 11/17/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import Foundation

public struct Topic{
    let id: Int
    let title: String
    let url: String
    
    init(id: Int, title: String, url: String) {
        self.id = id
        self.title = title
        self.url = url
    }
}
