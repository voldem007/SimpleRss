//
//  UICellView+Extension.swift
//  SimpleRss
//
//  Created by Voldem on 11/22/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    
    static var cellIdentifier: String {
        return String(describing: self)
    }
}
