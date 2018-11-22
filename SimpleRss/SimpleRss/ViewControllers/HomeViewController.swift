//
//  ViewController.swift
//  SimpleRss
//
//  Created by Voldem on 11/14/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let topics: [Topic] = [Topic(title: "IT", picUrl: "https://img.tyt.by/n/brushko/0e/9/perseidy_12082017_tutby_brush_phsl_-9131.jpg", feedUrl: "https://news.tut.by/rss/it.rss"),
                           Topic(title: "Economics", picUrl: "https://img.tyt.by/n/01/a/mid_belarusi_st.jpg", feedUrl: "https://news.tut.by/rss/economics.rss"),
                                 Topic(title: "Politics", picUrl: "https://img.tyt.by/n/it/0f/7/world-of-tanks.jpg", feedUrl: "https://news.tut.by/rss/politics.rss")]

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

extension HomeViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        navigateToFeed(feedUrl: topics[indexPath.row].feedUrl)
    }
}

extension HomeViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TopicViewCell.cellIdentifier()) as? TopicViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = topics[indexPath.row].title
        cell.previewImageView.downloaded(from: topics[indexPath.row].picUrl)
            
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

