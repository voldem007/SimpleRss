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
}

extension UITableViewCell{
    static func cellIdentifier() -> String {
        return String(describing: self)
    }
}
