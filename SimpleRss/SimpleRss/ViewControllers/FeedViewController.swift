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
        setupBinding()
    }
    
    fileprivate func setupUI() {
        title = "feed"
        let nib = UINib(nibName: FeedViewCell.cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: FeedViewCell.cellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        refreshControl = UIRefreshControl()
    }
    
    fileprivate func setupBinding() {
        viewModel
            .content
            .bind(to: tableView.rx.items(cellIdentifier: FeedViewCell.cellIdentifier)) { [weak self] row, feed, cell in
                guard
                    let cell = cell as? FeedViewCell,
                    let self = self else { return }
                
                cell.setup(feed, self)
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(FeedItemViewModel.self)
            .bind(to: viewModel.selectedFeed)
            .disposed(by: disposeBag)
        
        if let rc = refreshControl {
            viewModel
                .isBusy
                .asDriver()
                .drive(rc.rx.isRefreshing)
                .disposed(by: disposeBag)
        
            rc.rx
                .controlEvent(.valueChanged)
                .map { _ in rc.isRefreshing }
                .filter { $0 == true }
                .bind(to: viewModel.updateFeed)
                .disposed(by: disposeBag)
        }
    }
}

extension FeedViewController: FeedCellDelegate {
    
    func updateTableView() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

protocol FeedCellDelegate: class {
    
    func updateTableView()
}
