//
//  ViewController.swift
//  SimpleRss
//
//  Created by Voldem on 11/14/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: TopicViewCell.cellIdentifier(), bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: TopicViewCell.cellIdentifier())
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.onStateChanged = { [weak self] state in
            switch state {
            case .loaded:
                self?.tableView?.reloadData()
            case .failed(let error):
                print("\(error.debugDescription)")
            case .inProgress:
                print("in Progress")
            }
        }
        viewModel.loadTopics()
        
        title = "rss"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.onStateChanged = nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.showFeed(url: viewModel.content[indexPath.row].feedUrl)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.content.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TopicViewCell.cellIdentifier()) as? TopicViewCell else { return UITableViewCell() }
        
        let topic = viewModel.content[indexPath.row]
        
        cell.titleLabel.text = topic.title
        cell.imageUrl = URL(string: topic.picUrl)
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
