//
//  ViewModel.swift
//  SimpleRss
//
//  Created by Voldem on 6/23/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation
import RxSwift

protocol ViewModel: AnyObject {
    var isBusy: Observable<Bool> { get }
}
