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
    
    var feedList = [FeedViewModel]()
    var url: String?
    lazy var service: RssService = RssService()
    lazy var dataService: DataService = DataService()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    weak var tableView: UITableView!
    
    init(url: String) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
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
        
        getDataFromStorage()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        fetchXMLData()
        
        //self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func getDataFromStorage() {
       
        let feedModels = self.dataService.getFeed() ?? [FeedModel]()
        feedList = feedModels.map { feed in FeedViewModel(feed) }
        tableView.reloadData()
    }
    
    func fetchXMLData() {
        guard let url = url else { return }
        
        service.getFeed(for: url) { [weak self] (result, error) in
            guard let self = self, let feedList = result else { return }
            
            self.feedList = feedList.map { feed in FeedViewModel(feed) }
            self.dataService.saveFeed(feedList: feedList)
            
            //let op = self.dataService.getFeed()
            //if let pop = op {
             //   self.feedList = pop.map { feed in FeedViewModel(feed) }
            //}
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "feed";
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedViewCell.cellIdentifier()) as? FeedViewCell else { return UITableViewCell() }
        
        let feed = feedList[indexPath.row]
        
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
        return feedList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        guard let cell = tableView.cellForRow(at: indexPath) as? FeedViewCell else { return }
        
        let feed = feedList[indexPath.row]
        feed.toggle()
        cell.isExpanded = feed.isExpanded
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
