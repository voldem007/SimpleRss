//
//  RssDataService.swift
//  SimpleRss
//
//  Created by Voldem on 2/18/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

class RssDataService: DataService {
    
    private var persistentContainer: NSPersistentContainer {
        dataStore.preloadDataIfFirstLaunch()
        return dataStore.persistentContainer
    }
    
    private lazy var dataStore = {
        return DataStore()
    }()
    
    func getTopics() -> Single<[TopicModel]> {
        return Single<[TopicModel]>.create { [persistentContainer] single in
            persistentContainer.performBackgroundTask() { context in
                let fetch: NSFetchRequest<Topic> = Topic.fetchRequest()
                do {
                    let topics = try fetch.execute()
                    single(.success(topics.map { topic in
                        return TopicModel(title: topic.title ?? "", picUrl: topic.picLink ?? "", feedUrl: topic.feedUrl ?? "")
                    }))
                } catch let error {
                    single(.error(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func getFeed(by feedUrl: String) -> Maybe<[FeedModel]> {
        return Maybe<[FeedModel]>.create { [persistentContainer] maybe -> Disposable in
            persistentContainer.performBackgroundTask() { context in
                let fetch: NSFetchRequest<Topic> = Topic.fetchRequest()
                let predicate = NSPredicate(format: "feedUrl = %@", argumentArray : [feedUrl])
                fetch.predicate = predicate
                do {
                    let topic = try fetch.execute().first ?? Topic()
                    guard let feed = topic.feed else { return maybe(.completed) }
                    maybe(.success(feed.map { element in
                        let _element = element as? Feed
                        return FeedModel(guid: _element?.guid ?? UUID().uuidString ,title: _element?.title, pubDate: _element?.pubDate, picLinks: _element?.picLinks ?? [], description: _element?.text)
                    }))
                } catch let error {
                    maybe(.error(error))
                }
            }
            
            return Disposables.create()
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
            
            feedList.forEach { feedModel in
                let feed = Feed(context: context)
                feed.text = feedModel.description
                feed.pubDate = feedModel.pubDate
                feed.picLinks = feedModel.picLinks 
                feed.title = feedModel.title
                _topic?.addToFeed(feed)
            }
            
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
