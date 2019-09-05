//
//  DetailViewCell.swift
//  SimpleRss
//
//  Created by Voldem on 9/2/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation

class DetailViewCell: UICollectionViewCell {
    @IBOutlet private weak var pictureImageView: UIImageView!
    
    private var getOperation: GetImageOperation!
    
    private var imageUrl: URL? {
        didSet {
            guard let url = imageUrl else { return }
            getOperation = ImageDownloadOrchestrator.shared.download(url: url) { image in
                DispatchQueue.main.async {
                    self.pictureImageView.image = image
                }
            }
        }
    }
    
    func setup(pictureUrl: URL?) {
        imageUrl = pictureUrl
    }
    
    override func prepareForReuse() {
        pictureImageView.image = nil
        ImageDownloadOrchestrator.shared.cancel(getOperation)
    }
}
