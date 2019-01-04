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
}
