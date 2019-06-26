//
//  ViewModel.swift
//  SimpleRss
//
//  Created by Voldem on 6/23/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation
import RxRelay

protocol ViewModel: AnyObject {
    
    var isBusy: BehaviorRelay<Bool> { get }
}
