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
    
    private lazy var dataStore = { DataStore() }()
    
    func getTopics() -> Single<[TopicModel]> {
        return Single<[TopicModel]>.create { [persistentContainer] single in
            persistentContainer.performBackgroundTask() { context in
                let fetch: NSFetchRequest<Topic> = Topic.fetchRequest()
                do {
                    let topics = try fetch.execute()
                    single(.success(topics.map { topic in
                        return TopicModel(title: topic.title ?? "",
                                          picUrl: topic.picLink ?? "",
                                          feedUrl: topic.feedUrl ?? "")
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
                fetch.predicate = NSPredicate(format: "feedUrl = %@",
                                            argumentArray : [feedUrl])
                do {
                    let topic = try fetch.execute().first ?? Topic()
                    guard let feed = topic.feed else { return maybe(.completed) }
                    maybe(.success(feed.map { element in
                        let element = element as? Feed
                        return FeedModel(id: element?.id ?? UUID().uuidString,
                                         title: element?.title,
                                         pubDate: element?.pubDate,
                                         picLinks: element?.picLinks ?? [],
                                         description: element?.text,
                                         rating: element?.rating,
                                         comment: element?.comment)
                    }))
                } catch let error {
                    maybe(.error(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func saveFeed(feedList: [FeedModel], for url: String) {
        persistentContainer.performBackgroundTask() { [weak self] context in
            self?.deleteFeed(by: url, with: context)
            let fetch: NSFetchRequest<Topic> = Topic.fetchRequest()
            fetch.predicate = NSPredicate(format: "feedUrl = %@",
                                        argumentArray: [url])
            let topic = try? fetch.execute().first
            let feed = topic?.feed?.map { $0 as? Feed }

            feedList.forEach { feedModel in
                guard !(feed?.contains { $0?.id == feedModel.id } ?? false) else {
                    return
                }
                let feed = Feed(context: context)
                feed.text = feedModel.description
                feed.id = feedModel.id
                feed.pubDate = feedModel.pubDate
                feed.picLinks = feedModel.picLinks 
                feed.title = feedModel.title
                topic?.addToFeed(feed)
            }
            
            try? context.save()
        }
    }
    
    private func deleteFeed(by feedUrl: String, with context: NSManagedObjectContext) {
        let fetchForDelete: NSFetchRequest<NSFetchRequestResult> = Feed.fetchRequest()
        fetchForDelete.predicate = NSPredicate(format: "topic.feedUrl = %@ AND comment = NIL AND rating = NIL", argumentArray : [feedUrl])
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchForDelete)
        
        _ = try? context.execute(deleteRequest)
        
        context.reset()
    }
    
    func addComment(feedId: String, rating: Double, comment: String) {
        persistentContainer.performBackgroundTask() { context in
            let fetch: NSFetchRequest<Feed> = Feed.fetchRequest()
            fetch.predicate = NSPredicate(format: "id = %@", argumentArray : [feedId])
            let feed = try? fetch.execute().first
            feed?.rating = rating
            feed?.comment = comment
            try? context.save()
        }
    }
}
