//
//  ImageCache.swift
//  SimpleRss
//
//  Created by Voldem on 1/1/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation

final class ImageCache {
    let queue = OperationQueue()
    
    static var imagesCache: ImageCache?
    
    let imagesDirectory: URL
    
    static var shared = { () -> ImageCache in
        let cache = imagesCache ?? ImageCache()
        imagesCache = cache
        return cache
    }
    
    init() {
        queue.maxConcurrentOperationCount = 1
        
        imagesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("Images")
        
        if !FileManager.default.fileExists(atPath: imagesDirectory.path) {
            try? FileManager.default.createDirectory(at: imagesDirectory, withIntermediateDirectories: false, attributes: [:])
        }
        
        let lop = BlockOperation()
        lop.qualityOfService = .background
        
        if var cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            cachesDirectory.appendPathComponent("/Images")
            let urls = try? FileManager.default.contentsOfDirectory(at: cachesDirectory, includingPropertiesForKeys: [URLResourceKey.creationDateKey], options: [FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants])
           
            urls?.forEach({ url in
                if FileManager.default.fileExists(atPath: url.path) {
                    let op = BlockOperation()
                    op.qualityOfService = .background
                    
                    op.addExecutionBlock {
                        try? FileManager.default.removeItem(atPath: url.path)
                    }
                    
                    queue.addOperation(op)
                }
            })
            
            //var values = try? op?.first?.resourceValues(forKeys: [.creationDateKey])
            //if let date = values??.creationDate{
               // print(date)
            //}
        }
    }
}
