//
//  SaveImageOperation.swift
//  SimpleRss
//
//  Created by Voldem on 1/1/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import UIKit

final class SaveImageOperation: AsyncOperation {
    let path: String
    var image: UIImage
    
    init(_ path: String, _ image: UIImage) {
        self.path = path
        self.image = image
        super.init()
    }
    
    override func start() {
        super.start()
        
        saveImage(imageName: path, image: self.image)
        
        if isCancelled {
            state = .finished
            return
        }
        state = .finished
    }
    
    func saveImage(imageName: String, image: UIImage) {
        let imagesDirectory = ImageCache.shared.imagesDirectory
        
        let fileURL = imagesDirectory.appendingPathComponent(imageName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            try? data.write(to: fileURL)
        }
    }
}
