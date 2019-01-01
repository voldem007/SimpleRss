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
        super.start()
        
        let image = imageLoad(imageUrl: url)
        
        if isCancelled {
            state = .finished
            return
        }
        self.result = image
        self.state = .finished
    }
    
    private func imageLoad(imageUrl: URL) -> UIImage? {
        let data = try? Data(contentsOf: imageUrl)
        guard let data1 = data else { return nil }
        return UIImage(data: data1)
    }
}
