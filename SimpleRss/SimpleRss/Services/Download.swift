//
//  Download.swift
//  SimpleRss
//
//  Created by Voldem on 1/4/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation

final class Download {
    let queue = OperationQueue()
    static var downloadQueue: Download?
    
    static var shared = { () -> Download in
        let cache = downloadQueue ?? Download()
        downloadQueue = cache
        return cache
    }
    
    init() {
        queue.maxConcurrentOperationCount = 5
    }
}
