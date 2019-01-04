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
    
    weak var downloadOperation: DownloadImageOperation?
    weak var getOperation: GetImageOperation?
    
    var imageUrl: URL? {
        didSet {
            previewImageView.image = nil
            
            getOperation?.cancel()
            downloadOperation?.cancel()
            
            let getOp = GetImageOperation((imageUrl?.lastPathComponent)!)
            getOperation = getOp
            
            let downloadOp = DownloadImageOperation(imageUrl!)
            downloadOperation = downloadOp

            retrieveImage(downloadOp, getOp) { [weak self] image in
                OperationQueue.main.addOperation { [weak self] in
                    guard let self = self else { return }
                    self.previewImageView.image = image
                }
            }
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
}
