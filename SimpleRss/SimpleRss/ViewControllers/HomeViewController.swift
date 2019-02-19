//
//  ViewController.swift
//  SimpleRss
//
//  Created by Voldem on 11/14/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    lazy var topics: [TopicModel] = dataService.getTopics() ?? [TopicModel]()
    
    lazy var dataService: DataService = DataService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView(frame: view.bounds)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: TopicViewCell.cellIdentifier(), bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: TopicViewCell.cellIdentifier())
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "rss"
    }
    
    private func navigateToFeed(feedUrl: String) {
        navigationController?.pushViewController(FeedViewController(url: feedUrl), animated: true)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        navigateToFeed(feedUrl: topics[indexPath.row].feedUrl)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TopicViewCell.cellIdentifier()) as? TopicViewCell else { return UITableViewCell() }
        
        let topic = topics[indexPath.row]
        
        cell.titleLabel.text = topic.title
        cell.imageUrl = URL(string: topic.picUrl)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

