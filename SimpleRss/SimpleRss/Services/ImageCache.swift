//
//  ImageCache.swift
//  SimpleRss
//
//  Created by Voldem on 1/1/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation

final class ImageCache {
    static let shared = ImageCache()
    private let operationQueue: OperationQueue
    
    lazy var imagesDirectoryURL: URL = {
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return URL(fileURLWithPath: "") }
        return cacheDirectory.appendingPathComponent("Images")
    }()
    
    private init() {
        operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        
        imagesDirectoryURL.createIfEmptyCacheImageDirectory()
        imagesDirectoryURL.deleteInnerExpiredFiles(operationQueue: operationQueue)
    }
    
    func addOperation(_ op: Operation) {
        operationQueue.addOperation(op)
    }
}
