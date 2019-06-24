//
//  FeedViewController.swift
//  SimpleRss
//
//  Created by Voldem on 11/14/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import UIKit

class FeedViewController: UITableViewController {
    
    private let viewModel: FeedViewModel
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: FeedViewCell.cellIdentifier(), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: FeedViewCell.cellIdentifier())

        tableView.rowHeight = UITableView.automaticDimension
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        self.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.onStateChanged = { [weak self] state in
            switch state {
            case .loaded:
                self?.tableView?.reloadData()
                self?.refreshControl?.endRefreshing()
            case .failed(let error):
                print("\(error.debugDescription)")
            case .inProgress:
                print("in Progress")
            }
        }
        
        viewModel.getLocalData()
        
        title = "feed"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.onStateChanged = nil
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        viewModel.getNetworkData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedViewCell.cellIdentifier()) as? FeedViewCell else { return UITableViewCell() }
        
        let feed = viewModel.content[indexPath.row]
        
        cell.titleLabel.text = feed.title
        if let url = feed.picUrl {
            cell.imageUrl = URL(string: url)
        }
        cell.descriptionLabel.text = feed.description
        cell.pubDateLabel.text = feed.pubDate
        cell.expanding(isExpanded: feed.isExpanded)
     
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.content.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FeedViewCell else { return }
        
        let feed = viewModel.content[indexPath.row]
        feed.toggle()
        cell.isExpanded = feed.isExpanded
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
