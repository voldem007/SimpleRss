//
//  CellViewExtensions.swift
//  SimpleRss
//
//  Created by Voldem on 11/22/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import UIKit

extension UITableViewCell{
    static func cellIdentifier() -> String {
        return String(describing: self)
    }
}
