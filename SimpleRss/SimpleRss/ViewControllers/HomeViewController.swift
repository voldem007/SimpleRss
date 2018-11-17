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
    var tableView: UITableView?
    var dataSource: TopicsSource?
    var tableDelegate: TopicsDelegate?
    
    let topics: [Topic] = [Topic(id: 0, title: "IT", url: "https://img.tyt.by/n/brushko/0e/9/perseidy_12082017_tutby_brush_phsl_-9131.jpg"),
                                 Topic(id: 1, title: "Economics", url: "https://img.tyt.by/n/01/a/mid_belarusi_st.jpg"),
                                 Topic(id: 2, title: "Politics", url: "https://img.tyt.by/n/it/0f/7/world-of-tanks.jpg")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds)
        dataSource = TopicsSource(context: self)
        tableDelegate = TopicsDelegate(context: self)
        tableView?.dataSource = dataSource
        tableView?.delegate = tableDelegate
        
        let nib = UINib(nibName: "TopicViewCell", bundle: nil)
        
        tableView?.register(nib, forCellReuseIdentifier: "TopicViewCell")
        tableView?.estimatedRowHeight = 50
        tableView?.rowHeight = UITableView.automaticDimension
        
        self.view.addSubview(tableView!)
        tableView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "rss"
    }
}

internal class TopicsDelegate: NSObject, UITableViewDelegate
{
    weak var context: HomeViewController?
    
    init(context: HomeViewController?) {
        self.context = context
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        context?.navigationController?.pushViewController(FeedViewController(name: indexPath.row), animated: true)
    }
}

internal class TopicsSource: NSObject, UITableViewDataSource
{
    weak var context: HomeViewController?
    
    init(context: HomeViewController?) {
        self.context = context
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (context?.topics.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicViewCell")! as! TopicViewCell
        cell.TitleLabel?.text = self.context?.topics[indexPath.row].title
        
        let url = URL(string: (self.context?.topics[indexPath.row].url)!)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                cell.PreviewImageView.image = UIImage(data: data!)
            }
        }
            
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

