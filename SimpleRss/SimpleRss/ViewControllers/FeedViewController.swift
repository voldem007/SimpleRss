//
//  FeedViewController.swift
//  SimpleRss
//
//  Created by Voldem on 11/14/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FeedViewController: UITableViewController {
    
    private let viewModel: FeedViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupSub()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "feed"
    }
    
    fileprivate func setupUI() {
        let nib = UINib(nibName: FeedViewCell.cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: FeedViewCell.cellIdentifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let refreshControl = UIRefreshControl()
        self.refreshControl = refreshControl
    }
    
    fileprivate func setupSub() {
        viewModel.content
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: FeedViewCell.cellIdentifier)) { row, feed, cell in
                guard let feedCell = cell as? FeedViewCell else { return }
                feedCell.titleLabel.text = feed.title
                if let url = feed.picUrl {
                    feedCell.imageUrl = URL(string: url)
                }
                feedCell.descriptionLabel.text = feed.description
                feedCell.pubDateLabel.text = feed.pubDate
                feedCell.expanding(isExpanded: feed.isExpanded)
            }
            .disposed(by: disposeBag)
        
        viewModel.isBusy
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] event in
                guard let self = self else { return }
                guard let isBusy = event.element, isBusy else {
                    self.refreshControl?.endRefreshing()
                    return
                }
            }
            .disposed(by: disposeBag)
        
        refreshControl?.rx
            .controlEvent(.valueChanged)
            .map { [weak self] _ in self?.refreshControl?.isRefreshing }
            .filter { $0 == true }
            .subscribe { [weak self] _ in
                self?.viewModel.getNetworkData()
            }
            .disposed(by: disposeBag)
    }
}
