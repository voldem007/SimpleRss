//
//  GetImageOperation.swift
//  SimpleRss
//
//  Created by Voldem on 1/1/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import UIKit

final class GetImageOperation: AsyncOperation {
    let path: String
    var result: UIImage?
    
    init(_ path: String) {
        self.path = path
        super.init()
    }
    
    override func start() {
        super.start()
        
        let image = loadImageFromDiskWith(fileName: path)
        
        if isCancelled {
            state = .finished
            return
        }
        result = image
        state = .finished
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        let imagesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("Images") //ImageCache.shared().imagesDirectory
        let imageUrl = imagesDirectory.appendingPathComponent(fileName)
        return UIImage(contentsOfFile: imageUrl.path)
    }
}
