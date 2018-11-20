//
//  FeedViewCell.swift
//  SimpleRss
//
//  Created by Voldem on 11/19/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import UIKit

class FeedViewCell: UITableViewCell {
    
    @IBOutlet weak var PreviewImageView: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
}

extension FeedViewCell{
    static func cellIdentifier() -> String {
        return String(describing: self)
    }
}
