//
//  DownloadManager.swift
//  SimpleRss
//
//  Created by Voldem on 1/4/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation

final class DownloadManager {
    static let shared = DownloadManager()
    private let operationQueue: OperationQueue
    
    private init() {
        operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 5
    }
    
    func addOperation(_ op: Operation) {
        operationQueue.addOperation(op)
    }
}
