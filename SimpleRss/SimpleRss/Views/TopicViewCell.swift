//
//  TopicViewCell.swift
//  SimpleRss
//
//  Created by Voldem on 11/17/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import UIKit

class TopicViewCell: UITableViewCell {
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var getOperation: GetOp?
    
    var imageUrl: URL? {
        didSet {
            guard let url = imageUrl else { return }
            getOperation = Orchestrator.sharedInstance().download(url) { [weak self] image in
                guard let self = self else { return }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.previewImageView.image = image
                }
            }
        }
    }
    
    override func prepareForReuse() {
        previewImageView.image = nil
        Orchestrator.sharedInstance().cancel(getOperation)
    }
}
