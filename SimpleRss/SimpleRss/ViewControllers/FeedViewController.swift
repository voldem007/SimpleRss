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
    
    let feedCellIdentifier = "FeedViewCell"
    
    var name: String!
    
    var tableView: UITableView?
    var dataSource: FeedSource?
   // var tableDelegate: TopicsDelegate?
    
    init(name: Int){
        super.init(nibName: nil, bundle: nil)
        self.name = String(name)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds)
        
        dataSource = FeedSource(context: self)
        tableView?.dataSource = dataSource
        tableView?.register(FeedViewCell.self, forCellReuseIdentifier: feedCellIdentifier)
        tableView?.estimatedRowHeight = 50
        tableView?.rowHeight = UITableView.automaticDimension
        
        self.view.addSubview(tableView!)
        tableView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = name;
    }
}

internal class FeedSource: NSObject, UITableViewDataSource
{
    var context: FeedViewController?
    
    init(context: FeedViewController?) {
        self.context = context
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: (self.context?.feedCellIdentifier)!)! as! FeedViewCell
        
        cell.titleLabel.text = "Title"
        let url = URL(string: "https://img.tyt.by/n/it/0f/7/world-of-tanks.jpg")
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                cell.imageView?.image = UIImage(data: data!)
            }
        }
        
        cell.dateLabel.text = "10/10/2010"
        cell.descriptionLabel.text = "asdasdasdasdasdasdasdasdasdasd"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

