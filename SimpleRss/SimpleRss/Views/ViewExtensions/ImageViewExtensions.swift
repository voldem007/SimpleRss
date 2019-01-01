//
//  ImageViewExtensions.swift
//  SimpleRss
//
//  Created by Voldem on 12/13/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import UIKit
import Foundation

extension UIImageView {
    func downloaded(from link: String) {
        let operationQueue = OperationQueue()
        guard let url = URL(string: link) else { return }
        let operation = DownloadImageOperation(url)
        operation.completionBlock = {
            OperationQueue.main.addOperation {
                self.image = operation.result
            }
        }
        operationQueue.addOperation(operation)
    }
}
