//
//  FeedViewController.swift
//  SimpleRss
//
//  Created by Voldem on 11/14/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import Foundation
import UIKit

class FeedViewController: UIViewController {
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    private let viewModel: FeedViewModel
    private weak var tableView: UITableView!
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView(frame: view.bounds)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: FeedViewCell.cellIdentifier(), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: FeedViewCell.cellIdentifier())

        tableView.rowHeight = UITableView.automaticDimension
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        view.addSubview(tableView)
        tableView.addSubview(refreshControl)
        
        self.tableView = tableView;
        
        viewModel.getData { [weak self] in
            DispatchQueue.main.async {
                self?.tableView?.reloadData()
            }
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        viewModel.fetchXmlData() { [weak self] in
            DispatchQueue.main.async {
                self?.tableView?.reloadData()
            }
        }
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "feed";
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedViewCell.cellIdentifier()) as? FeedViewCell else { return UITableViewCell() }
        
        let feed = viewModel.feedList[indexPath.row]
        
        cell.titleLabel.text = feed.title
        if let url = feed.picUrl {
            cell.imageUrl = URL(string: url)
        }
        cell.descriptionLabel.text = feed.description
        cell.pubDateLabel.text = feed.pubDate
        cell.expanding(isExpanded: feed.isExpanded)
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.feedList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        guard let cell = tableView.cellForRow(at: indexPath) as? FeedViewCell else { return }
        
        let feed = viewModel.feedList[indexPath.row]
        feed.toggle()
        cell.isExpanded = feed.isExpanded
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
