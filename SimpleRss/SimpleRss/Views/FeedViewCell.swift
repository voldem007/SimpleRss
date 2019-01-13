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
    
    var getOperation: GetImageOperation?
    
    var imageUrl: URL? {
        didSet {
            guard let url = imageUrl else { return }
            ImageDownloadOrchestrator.shared.cancel(getOperation)
            getOperation = ImageDownloadOrchestrator.shared.download(url: url) { [weak self] image in
                guard let self = self else { return }
                DispatchQueue.main.async { [weak self] in
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
