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

    private let rssDataService: DataService
    private weak var delegate: HomeViewModelDelegeate?
    private let disposeBag = DisposeBag()
    
    lazy var content = { return loadTopics() }()
    var selectedTopic = PublishRelay<TopicModel>()
    
    init(dataService: DataService, delegate: HomeViewModelDelegeate) {
        self.rssDataService = dataService
        self.delegate = delegate
        
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
    
    func loadTopics() -> Observable<[TopicModel]> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return  Disposables.create() }
            let subscription = self.rssDataService.getTopics().subscribe(onSuccess: { topics in
                observer.onNext(topics)
                observer.onCompleted()
            }, onError: { error in
                observer.onError(error)
            })
            
            return subscription
        }
    }
    
    func showFeed(url: String) {
        delegate?.userDidSelectFeed(url: url)
    }
}
