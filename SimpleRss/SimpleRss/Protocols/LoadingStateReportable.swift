//
//  LoadingStateReportable.swift
//  SimpleRss
//
//  Created by Voldem on 6/23/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation

enum LoadingState {
    
    case inProgress
    case failed(_ error: Error?)
    case loaded
}

protocol LoadingStateReportable: AnyObject {
    
    var onStateChanged: ((LoadingState) -> Void)? { get set }
}
