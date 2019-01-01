//
//  ImageCache.swift
//  SimpleRss
//
//  Created by Voldem on 1/1/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation

class ImageCache {
    let queue = OperationQueue()
    
    static let shared = {
        return ImageCache()
    }
    
    init() {
        queue.maxConcurrentOperationCount = 1
    }
}
