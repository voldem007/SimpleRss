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
        self.result = image
        self.state = .finished
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        
        return nil
    }
}
