//
//  DownloadImageManager.swift
//  SimpleRss
//
//  Created by Voldem on 1/4/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import UIKit

class ImageDownloadManager: DownloadManager {
    
    private let operationQueue: OperationQueue
    
    required init(maxConcurrentOperation: Int) {
        operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = maxConcurrentOperation
    }
    
    func download(url: URL) -> DownloadImageOperation {
        let op = DownloadImageOperation(url)
        addOperation(op)
        return op
    }
    
    private func addOperation(_ op: Operation) {
        operationQueue.addOperation(op)
    }
}
