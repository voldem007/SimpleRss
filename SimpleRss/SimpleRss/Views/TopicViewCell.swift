//
//  TopicViewCell.swift
//  SimpleRss
//
//  Created by Voldem on 11/17/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import UIKit

class TopicViewCell: UITableViewCell {
    
    @IBOutlet private weak var previewImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private var getOperation: GetImageOperation!
    
    var imageUrl: URL? {
        didSet {
            guard let url = imageUrl else { return }
            getOperation = ImageDownloadOrchestrator.shared.download(url: url) { [weak self] image in
                guard let self = self else { return }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.previewImageView.image = image
                }
            }
        }
    }
    
    func setup(_ topic: TopicModel) {
        titleLabel.text = topic.title
        imageUrl = URL(string: topic.picUrl)
    }
    
    override func prepareForReuse() {
        previewImageView.image = nil
        ImageDownloadOrchestrator.shared.cancel(getOperation)
    }
}
