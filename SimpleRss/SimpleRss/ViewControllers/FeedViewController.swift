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
    
    var feedList = [Feed]()
    var url: String?
    
    weak var tableView: UITableView!
    
    init(url: String!) {
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
        self.tableView = tableView;
        
        fetchXMLData()
    }
    
    func fetchXMLData() {
        XMLParserService().fetchXMLData(for: url) { (feedList, error) in
            if error == nil {
                self.feedList = feedList!
                self.tableView.reloadData()
            }
            else {
                print(error?.localizedDescription ?? "Error")
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
        cell.previewImageView.downloaded(from: feed.picUrl)
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
        
        feedList[indexPath.row].isExpanded = !feedList[indexPath.row].isExpanded
        let isExpanded = feedList[indexPath.row].isExpanded
        cell.expanding(isExpanded: isExpanded)
        
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

