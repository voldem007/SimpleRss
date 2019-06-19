//
//  NetworkService.swift
//  SimpleRss
//
//  Created by Voldem on 6/19/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation

protocol NetworkService {
    
    func getFeed(for link: String?, withCallback completionHandler: @escaping(_ result: [FeedModel]?, _ error: Error?) -> Void)
}
