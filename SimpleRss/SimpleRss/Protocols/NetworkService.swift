//
//  NetworkService.swift
//  SimpleRss
//
//  Created by Voldem on 6/19/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation
import RxSwift

protocol NetworkService {    
    func getFeed(for url: URL) -> Single<[FeedModel]>
}
