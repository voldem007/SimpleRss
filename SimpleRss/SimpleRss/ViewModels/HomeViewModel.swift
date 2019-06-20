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

protocol HomeViewModel: AnyObject {
    
    var onTopicsChanged: (() -> Void)? { get set }
    
    var topics: [TopicModel] { get }
    
    init(dataService: DataService, delegate: HomeViewModelDelegeate)
    
    func getTopics()
    func showFeed(url: String)
}

class HomeViewModelImplementation: HomeViewModel {
    
    private let rssDataService: DataService
    private weak var delegate: HomeViewModelDelegeate?
    var onTopicsChanged: (() -> Void)?
    
    private(set) var topics = [TopicModel]()
    
    required init(dataService: DataService, delegate: HomeViewModelDelegeate) {
        self.rssDataService = dataService
        self.delegate = delegate
    }
    
    func getTopics() {
        rssDataService.getTopics(){ [weak self] _topics in
            self?.topics = _topics ?? [TopicModel]()
            self?.onTopicsChanged?()
        }
    }
    
    func showFeed(url: String) {
        delegate?.userDidSelectFeed(url: url)
    }
}
