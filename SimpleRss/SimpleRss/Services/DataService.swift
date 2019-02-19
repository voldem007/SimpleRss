//
//  DataService.swift
//  SimpleRss
//
//  Created by Voldem on 2/18/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation
import CoreData

class DataService {
    
    lazy var cacheContext: NSManagedObjectContext = {
        return appDelegate.persistentContainer.newBackgroundContext()
    }()
    
    lazy var updateContext: NSManagedObjectContext = {
        let _updateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        _updateContext.parent = parentContext
        return _updateContext
    }()
    
    private lazy var appDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    
    private var parentContext: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    func getFeed() -> [FeedModel]? {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Feed")
        let feedList = try? updateContext.fetch(fetchRequest)
        let feedModels = feedList?.compactMap({ element -> FeedModel in
            let feed = element as? Feed
            return FeedModel(title: feed?.title, pubDate: feed?.pubDate, picLink: feed?.picLink, description: feed?.text)
        })
        return feedModels
    }
    
    func saveFeed(feedList: [FeedModel]) {
        
        feedList.forEach({ feedModel in
            let entity = NSEntityDescription.entity(forEntityName: "Feed", in: updateContext)
            guard let e = entity else { return }
            
            let feed = NSManagedObject(entity: e, insertInto: updateContext)
            feed.setValue(feedModel.description, forKeyPath: "text")
            feed.setValue(feedModel.pubDate, forKeyPath: "pubDate")
            feed.setValue(feedModel.picLink, forKeyPath: "picLink")
            feed.setValue(feedModel.title, forKeyPath: "title")
            
            try? updateContext.save()
            try?  updateContext.parent?.save()
        })
    }
}
