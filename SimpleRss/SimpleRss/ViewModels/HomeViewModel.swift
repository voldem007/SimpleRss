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

    var content: Observable<[TopicModel]> { get }
    var selectedTopic: PublishRelay<TopicModel> { get }
}

class HomeViewModelImplementation: HomeViewModel {

    private weak var delegate: HomeViewModelDelegeate?
    private let disposeBag = DisposeBag()
    
    var content: Observable<[TopicModel]>
    var selectedTopic = PublishRelay<TopicModel>()
    
    init(rssDataService: DataService, delegate: HomeViewModelDelegeate) {
        self.delegate = delegate
        self.content = rssDataService.getTopics().asObservable()
        
        setBinding()
    }
}

extension HomeViewModelImplementation {
    
    func setBinding() {
        selectedTopic.map({ $0.feedUrl }).subscribe { [weak self] event in
            guard let self = self, let url = event.element else { return }
            self.showFeed(url: url)
            }
            .disposed(by: disposeBag)
    }    
    
    func showFeed(url: String) {
        delegate?.userDidSelectFeed(url: url)
    }
}
