//
//  GetImageOperation.swift
//  SimpleRss
//
//  Created by Voldem on 1/1/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import UIKit

final class GetImageOperation: AsyncOperation {
    
    let url: URL
    var result: UIImage?
    
    init(_ url: URL) {
        self.url = url
        super.init()
    }
    
    override func start() {
        super.start()
        
        let image = loadImageFromDiskWith(url: url)
        
        result = image
        state = .finished
    }
    
    func loadImageFromDiskWith(url: URL) -> UIImage? {
        guard !FileManager.default.fileExists(atPath: url.absoluteString) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
}
