//
//  HomeViewModel.swift
//  SimpleRss
//
//  Created by Voldem on 6/17/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation

class HomeViewModel {
    private let dataService: DataService
    
    var topics = [TopicModel]()
    
    init(dataService: DataService) {
        self.dataService = dataService
    }
    
    func getTopics(completion: @escaping () -> Void) {
        dataService.getTopics(){ [weak self] _topics in
            self?.topics = _topics ?? [TopicModel]()
            completion()
        }
    }
}
