//
//  Networking.swift
//  SimpleRss
//
//  Created by Voldem on 3/14/20.
//  Copyright © 2020 Vladimir Koptev. All rights reserved.
//

import Foundation

protocol Network {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

class Networking: Network {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: url) { (data, response, error) in
            completionHandler(data, response, error)
        }
    }
}
