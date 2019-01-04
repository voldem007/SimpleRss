//
//  DownloadImageOperation.swift
//  SimpleRss
//
//  Created by Voldem on 1/1/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import UIKit

final class DownloadImageOperation : AsyncOperation {
    let url: URL
    var result: UIImage?
    
    init(_ url: URL) {
        self.url = url
        super.init()
    }
    
    override func start() {
        if isCancelled {
            state = .finished
            return
        }
        
        super.start()
        
        let image = imageLoad(imageUrl: url)
        
        if isCancelled {
            state = .finished
            return
        }
        result = image
        state = .finished
    }
    
    private func imageLoad(imageUrl: URL) -> UIImage? {
        guard let data = try? Data(contentsOf: imageUrl) else { return nil }
        return UIImage(data: data)
    }
}
