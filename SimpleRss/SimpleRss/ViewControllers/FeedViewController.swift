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

        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.view.addSubview(tableView)
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
        cell.PreviewImageView?.downloaded(from: "https://img.tyt.by/n/it/0f/7/world-of-tanks.jpg")
        
        cell.DescriptionLabel.text = "ssdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdadasdasdasdasd"
     
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
        
        let cell = tableView.cellForRow(at: indexPath) as! FeedViewCell
        
        cell.DescriptionLabel.numberOfLines = cell.DescriptionLabel.numberOfLines == 0 ? 1 : 0;
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension UIImageView {
    func downloaded(from link: String) {
        DispatchQueue.global().async {
            guard let url = URL(string: link) else { return }
            guard let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
    }
}

