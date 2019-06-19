//
//  DownloadOrchestrator.swift
//  SimpleRss
//
//  Created by Voldem on 1/13/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import UIKit

protocol DownloadOrchestrator {
    
    init(cacheManager: CacheManager, downloadManager: DownloadManager)
    
    func download(url: URL, _ completion: @escaping(_ image: UIImage?) -> Void) -> GetImageOperation
    func cancel(_ op: AsyncOperation?)
}
