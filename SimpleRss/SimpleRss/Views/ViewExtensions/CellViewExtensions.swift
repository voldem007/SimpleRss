//
//  CellViewExtensions.swift
//  SimpleRss
//
//  Created by Voldem on 11/22/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import UIKit

extension UITableViewCell{
    static func cellIdentifier() -> String {
        return String(describing: self)
    }
    
    func retrieveImage(_ downloadOperation: DownloadImageOperation, _ getOperation: GetImageOperation, _ completion: @escaping(_ image: UIImage?) -> Void) {
        getOperation.completionBlock = {
            if let image = getOperation.result {
                completion(image)
            }
            else {
                downloadOperation.completionBlock = {
                    completion(downloadOperation.result)
                    
                    let path = downloadOperation.url.lastPathComponent
                    guard let image = downloadOperation.result else { return }
                    let saveOperation = SaveImageOperation(path, image)
                    ImageCache.shared().queue.addOperation(saveOperation)
                }
                Download.shared().queue.addOperation(downloadOperation)
            }
        }
        ImageCache.shared().queue.addOperation(getOperation)
    }
}
