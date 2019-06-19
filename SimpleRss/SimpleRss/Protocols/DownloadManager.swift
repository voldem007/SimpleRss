//
//  DownloadManager.swift
//  SimpleRss
//
//  Created by Voldem on 1/13/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation

protocol DownloadManager {
    
    init(maxConcurrentOperation: Int)
    
    func download(url: URL) -> DownloadImageOperation
}
