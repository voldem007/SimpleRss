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
    
    lazy var imagesDirectory: URL = {
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return URL(fileURLWithPath: "") }
        return cacheDirectory.appendingPathComponent("Images")
    }()
    
    private init() {
        operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        
        initCache()
        
        let urls = try? FileManager.default.contentsOfDirectory(at: imagesDirectory, includingPropertiesForKeys: [URLResourceKey.creationDateKey], options: [FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants])
        
        let urlsForDelete = urls?.filter({ url in
            var values = try? url.resourceValues(forKeys: [.creationDateKey])
            if let date = values?.creationDate {
                let days3Interval = Date().addingTimeInterval(-3*24*60*60).timeIntervalSinceNow
                let intervalSinceCreate = date.timeIntervalSinceNow
                return days3Interval > intervalSinceCreate
            }
            return false
        })
        
        urlsForDelete?.forEach({ url in
            if FileManager.default.fileExists(atPath: url.path) {
                let blockOperation = BlockOperation()
                blockOperation.qualityOfService = .background
                
                blockOperation.addExecutionBlock {
                    try? FileManager.default.removeItem(atPath: url.path)
                }
                operationQueue.addOperation(blockOperation)
            }
        })
    }
    
    private func initCache() {
        if !FileManager.default.fileExists(atPath: imagesDirectory.path) {
            try? FileManager.default.createDirectory(at: imagesDirectory, withIntermediateDirectories: false, attributes: [:])
        }
    }
    
    func addOperation(_ op: Operation) {
        operationQueue.addOperation(op)
    }
}
