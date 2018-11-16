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
        
        self.title = name;
    }
}

internal class FeedSource: NSObject, UITableViewDataSource
{
    var _context: FeedViewController?
    
    init(context: FeedViewController?) {
        _context = context
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // _context?.navigationController?.pushViewController(FeedViewController(name: indexPath.row), animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = reusableCell() //tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        cell.textLabel?.text = String(indexPath.row)
        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

