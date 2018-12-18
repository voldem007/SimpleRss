//
//  ImageViewExtensions.swift
//  SimpleRss
//
//  Created by Voldem on 12/13/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloaded(from link: String) {
        DispatchQueue.global().async {
            guard let url = URL(string: link), let data = try? Data(contentsOf: url) else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
