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
    
    lazy var updateContext: NSManagedObjectContext = {
        let _updateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        _updateContext.parent = viewContext
        return _updateContext
    }()
    
    private lazy var appDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    
    private var viewContext: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    func getTopics() -> [TopicModel]? {
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Topic")
        let topics = try? updateContext.fetch(fetch)
        
        return topics?.map { topic in
            let _topic = topic as? Topic
            return TopicModel(title: _topic?.title ?? "", picUrl: _topic?.picLink ?? "", feedUrl: _topic?.feedUrl ?? "")
        }
    }
    
    func getFeed(by feedUrl: String) -> [FeedModel]? {
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Topic")
        let predicate = NSPredicate(format: "feedUrl = %@", argumentArray : [feedUrl])
        fetch.predicate = predicate
        let topic = try? updateContext.fetch(fetch).first
        let _topic = topic as? Topic
        
        let feedModels: [FeedModel]? = _topic?.feed?.map { element in
            let _element = element as? Feed
            return FeedModel(title: _element?.title, pubDate: _element?.pubDate, picLink: _element?.picLink, description: _element?.text)
        }
        
        return feedModels?.count == 0 ? nil : feedModels
    }
    
    func saveFeed(feedList: [FeedModel], for url: String) {
        
        deleteFeed(by: url)
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Topic")
        let predicate = NSPredicate(format: "feedUrl = %@", argumentArray: [url])
        fetch.predicate = predicate
        let topic = try? updateContext.fetch(fetch).first
        let _topic = topic as? Topic
        
        feedList.forEach({ feedModel in            
            let feed = Feed(context: updateContext)
            feed.text = feedModel.description
            feed.pubDate = feedModel.pubDate
            feed.picLink = feedModel.picLink
            feed.title = feedModel.title
            _topic?.addToFeed(feed)
        })
        
        try? updateContext.save()
        try? updateContext.parent?.save()
    }
    
    func deleteFeed(by feedUrl: String) {
        
        let fetchForDelete = NSFetchRequest<NSFetchRequestResult>(entityName: "Feed")
        fetchForDelete.predicate = NSPredicate(format: "topic.feedUrl = %@", argumentArray : [feedUrl])
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchForDelete)
        
        _ = try? updateContext.execute(deleteRequest)
        
        updateContext.reset()
        updateContext.parent?.reset()
    }
}
