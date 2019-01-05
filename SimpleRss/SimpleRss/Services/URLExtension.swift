//
//  URLExtension.swift
//  SimpleRss
//
//  Created by Voldem on 1/6/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation

extension URL {
    public func createIfEmptyCacheImageDirectory() {
        if !FileManager.default.fileExists(atPath: self.path) {
            try? FileManager.default.createDirectory(at: self, withIntermediateDirectories: false, attributes: [:])
        }
    }
    
    public func deleteInnerExpiredFiles(operationQueue: OperationQueue) {
        let urls = getContents(by: self)
        let urlsForDelete = findExpiredURLs(urls)
        deleteExpiredFiles(urlsForDelete, operationQueue)
    }
    
    private func getContents(by url: URL) -> [URL]? {
        return try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [URLResourceKey.creationDateKey], options: [FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants])
    }
    
    private func findExpiredURLs(_ urls: [URL]?) -> [URL]? {
        return urls?.filter({ url in
            var values = try? url.resourceValues(forKeys: [.creationDateKey])
            if let date = values?.creationDate {
                guard let threeDaysInterval = Calendar.current.date(byAdding: .day, value: -3, to: Date()) else { return false }
                let days3Interval = threeDaysInterval.timeIntervalSinceNow
                let intervalSinceCreate = date.timeIntervalSinceNow
                return days3Interval > intervalSinceCreate
            }
            return false
        })
    }
    
    private func deleteExpiredFiles(_ urlsForDelete: [URL]?, _ operationQueue: OperationQueue) {
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
}
