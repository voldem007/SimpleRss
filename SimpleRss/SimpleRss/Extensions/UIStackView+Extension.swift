//
//  UIStackView+Extension.swift
//  SimpleRss
//
//  Created by Voldem on 12/26/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation

extension UIStackView {
    
    func removeAll() {
        for view in arrangedSubviews {
            view.removeFromSuperview()
        }
    }
}
