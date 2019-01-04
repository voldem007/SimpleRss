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
    
    weak var downloadOperation: DownloadImageOperation?
    weak var getOperation: GetImageOperation?

    func updateImage() {
        getOperation?.cancel()
        downloadOperation?.cancel()

        guard let path = imageUrl?.lastPathComponent else { return }
        let getImageOperation = GetImageOperation(path)
        getOperation = getImageOperation
        getImageOperation.completionBlock = { [weak self] in
            guard let self = self else { return }
            if let image = self.getOperation?.result {
                OperationQueue.main.addOperation {
                    self.previewImageView.image = image
                }
            }
            else {
                guard let url = self.imageUrl else { return }
                let downloadOperation = DownloadImageOperation(url)
                self.downloadOperation = downloadOperation
                downloadOperation.completionBlock = { [weak self] in
                    guard let self = self else { return }
                    OperationQueue.main.addOperation {
                        self.previewImageView.image = self.downloadOperation?.result
                    }
                    guard let path = self.downloadOperation?.url.lastPathComponent else { return }
                    guard let image = self.downloadOperation?.result else { return }
                    let saveOperation = SaveImageOperation(path, image)
                    ImageCache.shared().queue.addOperation(saveOperation)
                }
                Download.shared().queue.addOperation(downloadOperation)
            }
        }
        ImageCache.shared().queue.addOperation(getImageOperation)
    }
}
