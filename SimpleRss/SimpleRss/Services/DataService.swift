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
    
    private lazy var persistentContainer = {
        return appDelegate.persistentContainer
    }()
    
    private lazy var appDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    
    func getTopics(completion: @escaping([TopicModel]?) -> Void) {
        
        persistentContainer.performBackgroundTask() { context in

            let fetch: NSFetchRequest<Topic> = Topic.fetchRequest()
            let topics = try? fetch.execute()
            completion(topics?.map { topic in
                return TopicModel(title: topic.title ?? "", picUrl: topic.picLink ?? "", feedUrl: topic.feedUrl ?? "")
            })
        }
    }
    
    func getFeed(by feedUrl: String, completion: @escaping([FeedModel]?) -> Void) {
        
        persistentContainer.performBackgroundTask() { context in
            
            let fetch: NSFetchRequest<Topic> = Topic.fetchRequest()
            let predicate = NSPredicate(format: "feedUrl = %@", argumentArray : [feedUrl])
            fetch.predicate = predicate
            let topic = try? fetch.execute().first ?? Topic()
            
            completion(topic?.feed?.map { element in
                let _element = element as? Feed
                return FeedModel(title: _element?.title, pubDate: _element?.pubDate, picLink: _element?.picLink, description: _element?.text)
                })
        }
    }
    
    func saveFeed(feedList: [FeedModel], for url: String) {
        
        persistentContainer.performBackgroundTask() { [weak self] (context) in
            
            self?.deleteFeed(by: url, with: context)
            
            let fetch: NSFetchRequest<Topic> = Topic.fetchRequest()
            let predicate = NSPredicate(format: "feedUrl = %@", argumentArray: [url])
            fetch.predicate = predicate
            let topic = try? fetch.execute().first
            let _topic = topic as? Topic
            
            feedList.forEach({ feedModel in
                let feed = Feed(context: context)
                feed.text = feedModel.description
                feed.pubDate = feedModel.pubDate
                feed.picLink = feedModel.picLink
                feed.title = feedModel.title
                _topic?.addToFeed(feed)
            })
            
            try? context.save()
        }
    }
    
    private func deleteFeed(by feedUrl: String, with context: NSManagedObjectContext) {
        
        let fetchForDelete:NSFetchRequest<NSFetchRequestResult> = Feed.fetchRequest()
        fetchForDelete.predicate = NSPredicate(format: "topic.feedUrl = %@", argumentArray : [feedUrl])
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchForDelete)
        
        _ = try? context.execute(deleteRequest)
        
        context.reset()
    }
}
