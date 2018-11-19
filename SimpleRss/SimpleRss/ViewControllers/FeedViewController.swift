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
    weak var tableView: UITableView?
    
    init(name: Int){
        super.init(nibName: nil, bundle: nil)
        self.name = String(name)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView(frame: self.view.bounds)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: feedCellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: feedCellIdentifier)

        tableView.rowHeight = UITableView.automaticDimension
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.view.addSubview(tableView)
        self.tableView = tableView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = name;
    }
}

extension FeedViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.feedCellIdentifier) as! FeedViewCell
        
        cell.TitleLabel.text = "Title"
        let url = URL(string: "https://img.tyt.by/n/it/0f/7/world-of-tanks.jpg")
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                cell.imageView?.image = UIImage(data: data!)
            }
        }
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension FeedViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.navigationController?.pushViewController(FeedViewController(name: indexPath.row), animated: true)
    }
}

