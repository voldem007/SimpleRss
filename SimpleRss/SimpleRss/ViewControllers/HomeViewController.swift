//
//  ViewController.swift
//  SimpleRss
//
//  Created by Voldem on 11/14/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UITableViewController {
    
    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: TopicViewCell.cellIdentifier, bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: TopicViewCell.cellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        viewModel.content
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: TopicViewCell.cellIdentifier)) { row, topic, cell in
                guard let topicCell = cell as? TopicViewCell else { return }
                topicCell.titleLabel.text = topic.title
                topicCell.imageUrl = URL(string: topic.picUrl)
            }
            .disposed(by: disposeBag)
        
        tableView
            .rx
            .modelSelected(TopicModel.self)
            .map { $0.feedUrl }
            .subscribe(onNext: { [weak self] url in
                self?.viewModel.showFeed(url: url)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "rss"
    }
}
