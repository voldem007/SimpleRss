//
//  ViewController.swift
//  SimpleRss
//
//  Created by Voldem on 11/14/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController
{
    let topics: [Topic] = [Topic(title: "IT", url: "https://img.tyt.by/n/brushko/0e/9/perseidy_12082017_tutby_brush_phsl_-9131.jpg"),
                                 Topic(title: "Economics", url: "https://img.tyt.by/n/01/a/mid_belarusi_st.jpg"),
                                 Topic(title: "Politics", url: "https://img.tyt.by/n/it/0f/7/world-of-tanks.jpg")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView(frame: self.view.bounds)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: TopicViewCell.cellIdentifier(), bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: TopicViewCell.cellIdentifier())
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        self.view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "rss"
    }
    
    private func navigateToFeed(id: Int){
        navigationController?.pushViewController(FeedViewController(), animated: true)
    }
}

extension HomeViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        navigateToFeed(id: indexPath.row)
    }
}

extension HomeViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TopicViewCell.cellIdentifier()) as! TopicViewCell
        cell.TitleLabel?.text = self.topics[indexPath.row].title
        
        cell.PreviewImageView?.downloaded(from: self.topics[indexPath.row].url)
            
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

