//
//  ViewController.swift
//  SimpleRss
//
//  Created by Voldem on 11/14/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import UIKit

protocol HomeViewControllerDelegeate: AnyObject {
    func userDidSelectFeed(url: String)
}

class HomeViewController: UIViewController {
    
    private weak var tableView: UITableView?
    private let viewModel: HomeViewModel
    private weak var delegate: HomeViewControllerDelegeate?
    
    init(viewModel: HomeViewModel, delegate: HomeViewControllerDelegeate) {
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        self.tableView = tableView
        
        viewModel.getTopics(){ [weak self] in
            DispatchQueue.main.async {
                self?.tableView?.reloadData()
            }
        }

        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "rss"
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        delegate?.userDidSelectFeed(url: viewModel.topics[indexPath.row].feedUrl)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TopicViewCell.cellIdentifier()) as? TopicViewCell else { return UITableViewCell() }
        
        let topic = viewModel.topics[indexPath.row]
        
        cell.titleLabel.text = topic.title
        cell.imageUrl = URL(string: topic.picUrl)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

