//
//  HomeViewModel.swift
//  SimpleRss
//
//  Created by Voldem on 6/17/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

protocol HomeViewModelDelegeate: AnyObject {
    
    func userDidSelectFeed(url: String)
}

protocol HomeViewModel {

    var content: BehaviorRelay<[TopicModel]> { get }
    
    func loadTopics()
    func showFeed(url: String)
}

class HomeViewModelImplementation: HomeViewModel {

    private let rssDataService: DataService
    private weak var delegate: HomeViewModelDelegeate?
    private(set) var content = BehaviorRelay<[TopicModel]>(value: [])
    
    init(dataService: DataService, delegate: HomeViewModelDelegeate) {
        self.rssDataService = dataService
        self.delegate = delegate
        
        loadTopics()
    }
}

extension HomeViewModelImplementation {
    
    func loadTopics() {
        rssDataService.getTopics() { [weak self] result in
            guard let self = self else { return }
            guard let topics = result else { return }
            self.content.accept(topics)
        }
    }
    
    func showFeed(url: String) {
        delegate?.userDidSelectFeed(url: url)
    }
}
