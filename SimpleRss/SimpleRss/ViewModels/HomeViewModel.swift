//
//  HomeViewModel.swift
//  SimpleRss
//
//  Created by Voldem on 6/17/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation

protocol HomeViewModelDelegeate: AnyObject {
    
    func userDidSelectFeed(url: String)
}

class HomeViewModel {
    
    private let rssDataService: DataService
    private weak var delegate: HomeViewModelDelegeate?
    
    var topics = [TopicModel]()
    
    init(dataService: DataService, delegate: HomeViewModelDelegeate) {
        self.rssDataService = dataService
        self.delegate = delegate
    }
    
    func getTopics(completion: @escaping () -> Void) {
        rssDataService.getTopics(){ [weak self] _topics in
            self?.topics = _topics ?? [TopicModel]()
            completion()
        }
    }
    
    func showFeed(url: String) {
        delegate?.userDidSelectFeed(url: url)
    }
}
