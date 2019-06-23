//
//  ViewModel.swift
//  SimpleRss
//
//  Created by Voldem on 6/23/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation

protocol ViewModel: AnyObject {
    
    associatedtype Content: Collection
    
    var content: Content { get }
}
