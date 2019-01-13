//
//  FileCacheManager.swift
//  SimpleRss
//
//  Created by Voldem on 1/10/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import UIKit

class ImageCacheManager: CacheManager {
    private let expiredDays: Int
    private let imagesDirectoryURL: URL
    private let operationQueue: OperationQueue
    
    required init(imagesDirectoryURL: URL, expiredDays: Int) {
        self.expiredDays = expiredDays
        self.imagesDirectoryURL = imagesDirectoryURL
        operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        createIfEmptyCacheImageDirectory()
        deleteInnerExpiredFiles()
    }
    
    public func save(url: URL, image: UIImage) {
        let fileURL = imagesDirectoryURL.appendingPathComponent(url.lastPathComponent)
        let blockOperation = BlockOperation()
        blockOperation.addExecutionBlock {
            guard let data = image.jpegData(compressionQuality: 1) else { return }
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                try? data.write(to: fileURL)
            }
        }
        operationQueue.addOperation(blockOperation)
    }
    
    public func get(url: URL) -> GetImageOperation {
        let fileURL = imagesDirectoryURL.appendingPathComponent(url.lastPathComponent)
        let getOp = GetImageOperation(fileURL)
        operationQueue.addOperation(getOp)
        return getOp
    }
    
    private func deleteInnerExpiredFiles() {
        let urls = getContents(by: imagesDirectoryURL)
        let urlsForDelete = findExpiredURLs(urls)
        deleteExpiredFiles(urlsForDelete)
    }
    
    private func getContents(by url: URL) -> [URL]? {
        return try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [URLResourceKey.creationDateKey], options: [FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants])
    }
    
    private func findExpiredURLs(_ urls: [URL]?) -> [URL]? {
        return urls?.filter({ url in
            var values = try? url.resourceValues(forKeys: [.creationDateKey])
            if let date = values?.creationDate {
                guard let threeDaysInterval = Calendar.current.date(byAdding: .day, value: -(expiredDays), to: Date()) else { return false }
                let days3Interval = threeDaysInterval.timeIntervalSinceNow
                let intervalSinceCreate = date.timeIntervalSinceNow
                return days3Interval > intervalSinceCreate
            }
            return false
        })
    }
    
    private func deleteExpiredFiles(_ urlsForDelete: [URL]?) {
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
    
    private func createIfEmptyCacheImageDirectory() {
        if !FileManager.default.fileExists(atPath: imagesDirectoryURL.path) {
            try? FileManager.default.createDirectory(at: imagesDirectoryURL, withIntermediateDirectories: false, attributes: [:])
        }
    }
}
