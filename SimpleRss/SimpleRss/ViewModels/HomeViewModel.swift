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

protocol HomeViewModel: LoadingStateReportable, ViewModel where Content == [TopicModel] {
    
    func loadTopics()
    func showFeed(url: String)
}

class HomeViewModelImplementation: HomeViewModel {
    
    typealias Content = [TopicModel]

    private let rssDataService: DataService
    private weak var delegate: HomeViewModelDelegeate?
    
    var onStateChanged: ((LoadingState) -> Void)?

    private(set) var content = Content()
    
    init(dataService: DataService, delegate: HomeViewModelDelegeate) {
        self.rssDataService = dataService
        self.delegate = delegate
    }
}

extension HomeViewModelImplementation {
    
    func loadTopics() {
        reportState(.inProgress)
        rssDataService.getTopics(){ [weak self] result in
            guard let self = self else { return }
            guard let topics = result else {
                self.reportState(.failed(nil))
                return
            }
            self.content = topics
            self.reportState(.loaded)
        }
    }
    
    func showFeed(url: String) {
        delegate?.userDidSelectFeed(url: url)
    }
}
