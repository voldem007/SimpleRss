//
//  FeedViewCell.swift
//  SimpleRss
//
//  Created by Voldem on 11/19/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import UIKit

class FeedViewCell: UITableViewCell {
    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pubDateLabel: UILabel!
    
    var imageUrl: URL? {
        didSet {
            previewImageView.image = nil
            updateImage()
        }
    }
    
    var isExpanded: Bool = false {
        didSet {
            expanding(isExpanded: isExpanded)
        }
    }
    
    override func prepareForReuse() {
        previewImageView.image = nil
        expanding(isExpanded: false)
    }
    
    func expanding(isExpanded: Bool) {
        descriptionLabel.numberOfLines = isExpanded ? 0 : 1;
        descriptionLabel.lineBreakMode = isExpanded ? .byWordWrapping : .byTruncatingTail
    }
    
    var downloadOperation: DownloadImageOperation?
    var getOperation: GetImageOperation?
    let operationQueue = OperationQueue()

    func updateImage() {
        getOperation?.cancel()
        downloadOperation?.cancel()

        guard let path = imageUrl?.lastPathComponent else { return }
        getOperation = GetImageOperation(path)
        getOperation?.completionBlock = {
            if let image = self.getOperation?.result {
                OperationQueue.main.addOperation {
                    self.previewImageView.image = image
                }
            }
            else {
                self.operationQueue.maxConcurrentOperationCount = 5
                guard let url = self.imageUrl else { return }
                self.downloadOperation = DownloadImageOperation(url)
                self.downloadOperation?.completionBlock = {
                    OperationQueue.main.addOperation {
                        self.previewImageView.image = self.downloadOperation?.result
                    }
                    guard let path = self.downloadOperation?.url.lastPathComponent else { return }
                    guard let image = self.downloadOperation?.result else { return }
                    let saveOperation = SaveImageOperation(path, image)
                    ImageCache.shared().queue.addOperation(saveOperation)
                }
                self.operationQueue.addOperation(self.downloadOperation!)
            }
        }
        ImageCache.shared().queue.addOperation(getOperation!)
    }
}
