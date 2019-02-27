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
        _updateContext.persistentStoreCoordinator = appDelegate.persistentContainer.persistentStoreCoordinator
        return _updateContext
    }()
    
    private lazy var appDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    
    func getTopics() -> [TopicModel]? {
        
        let fetch: NSFetchRequest<Topic> = Topic.fetchRequest()
        let topics = try? updateContext.fetch(fetch)
        
        return topics?.map { topic in
            return TopicModel(title: topic.title ?? "", picUrl: topic.picLink ?? "", feedUrl: topic.feedUrl ?? "")
        }
    }
    
    func getFeed(by feedUrl: String) -> [FeedModel]? {
        
        var feedModels: [FeedModel]?
        updateContext.performAndWait {
            
            let fetch: NSFetchRequest<Topic> = Topic.fetchRequest()
            let predicate = NSPredicate(format: "feedUrl = %@", argumentArray : [feedUrl])
            fetch.predicate = predicate
            let topic = try? fetch.execute().first ?? Topic()
            
            feedModels = topic?.feed?.map { element in
                let _element = element as? Feed
                return FeedModel(title: _element?.title, pubDate: _element?.pubDate, picLink: _element?.picLink, description: _element?.text)
            }

        }
        return feedModels?.count == 0 ? nil : feedModels
    }
    
    func saveFeed(feedList: [FeedModel], for url: String) {
        
        deleteFeed(by: url)
        
        updateContext.perform { [weak self] in
            guard let self = self else { return }
        
            let fetch: NSFetchRequest<Topic> = Topic.fetchRequest()
            let predicate = NSPredicate(format: "feedUrl = %@", argumentArray: [url])
            fetch.predicate = predicate
            let topic = try? fetch.execute().first
            let _topic = topic as? Topic
            
            feedList.forEach({ feedModel in
                let feed = Feed(context: self.updateContext)
                feed.text = feedModel.description
                feed.pubDate = feedModel.pubDate
                feed.picLink = feedModel.picLink
                feed.title = feedModel.title
                _topic?.addToFeed(feed)
            })
            
            try? self.updateContext.save()
        }
    }
    
    func deleteFeed(by feedUrl: String) {
        
        updateContext.performAndWait {
        
            let fetchForDelete = NSFetchRequest<NSFetchRequestResult>(entityName: "Feed")
            fetchForDelete.predicate = NSPredicate(format: "topic.feedUrl = %@", argumentArray : [feedUrl])
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchForDelete)
            
            _ = try? updateContext.execute(deleteRequest)
            
            updateContext.reset()
        }
    }
}
