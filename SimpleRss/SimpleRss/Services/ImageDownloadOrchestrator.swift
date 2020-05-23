//
//  ImageDownloadManager.swift
//  SimpleRss
//
//  Created by Voldem on 1/1/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import UIKit

class ImageDownloadOrchestrator: DownloadOrchestrator {
    
    private static let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("Images")
    
    static let shared = ImageDownloadOrchestrator(cacheManager: ImageCacheManager(imagesDirectoryURL: path!, expiredDays: 3), downloadManager: ImageDownloadManager(maxConcurrentOperation: 5))
    
    let cacheManager: CacheManager
    let downloadManager: DownloadManager
    
    required init(cacheManager: CacheManager, downloadManager: DownloadManager) {
        self.cacheManager = cacheManager
        self.downloadManager = downloadManager
    }
    
    func download(url: URL, completion: @escaping(UIImage?) -> Void) -> GetImageOperation {
        let getOp = cacheManager.get(url: url)
        getOp.completionBlock = { [weak self] in
            guard let self = self else { return }
            guard !getOp.isCancelled else { return }
            
            completion(getOp.result)
            guard getOp.result == nil else { return }
            
            let downloadOperation = self.downloadManager.download(url: url)
            getOp.addDependency(downloadOperation)
            downloadOperation.completionBlock = { [weak self] in
                guard !downloadOperation.isCancelled else { return }
                completion(downloadOperation.result)
                guard let result = downloadOperation.result else { return }
                self?.cacheManager.save(url: downloadOperation.url, image: result)
            }
        }
        return getOp
    }
}
