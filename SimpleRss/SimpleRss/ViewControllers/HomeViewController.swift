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
        
        setupUI()
        setupBinding()
    }
    
    fileprivate func setupUI() {
        title = "rss"
        let nib = UINib(nibName: TopicViewCell.cellIdentifier, bundle: nil) 
        tableView.register(nib, forCellReuseIdentifier: TopicViewCell.cellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    fileprivate func setupBinding() {
        viewModel.content
            .bind(to: tableView.rx.items(cellIdentifier: TopicViewCell.cellIdentifier)) { row, topic, cell in
                guard let topicCell = cell as? TopicViewCell else { return }
                topicCell.titleLabel.text = topic.title
                topicCell.imageUrl = URL(string: topic.picUrl)
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(TopicModel.self)
            .bind(to: viewModel.selectedTopic)
            .disposed(by: disposeBag)
    }
}
