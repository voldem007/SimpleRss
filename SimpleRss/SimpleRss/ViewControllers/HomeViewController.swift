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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds)
        dataSource = TopicsSource(context: self)
        tableDelegate = TopicsDelegate(context: self)
        tableView?.dataSource = dataSource
        tableView?.delegate = tableDelegate
        
        let nib = UINib(nibName: "TopicCell", bundle: nil)
        
        tableView?.register(nib, forCellReuseIdentifier: "TopicCell")
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
    weak var _context: HomeViewController?
    
    init(context: HomeViewController?) {
        _context = context
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        _context?.navigationController?.pushViewController(FeedViewController(name: indexPath.row), animated: true)
    }
}

internal class TopicsSource: NSObject, UITableViewDataSource
{
    weak var _context: HomeViewController?
    
    init(context: HomeViewController?) {
        _context = context
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell")! as! TopicCell
        cell.NameLabel?.text = String(indexPath.row)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

