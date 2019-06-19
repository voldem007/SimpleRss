//
//  CacheManager.swift
//  SimpleRss
//
//  Created by Voldem on 1/13/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import UIKit

protocol CacheManager {
    
    init(imagesDirectoryURL: URL, expiredDays: Int)
    
    func save(url: URL, image: UIImage)
    func get(url: URL) -> GetImageOperation
}
