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
                    single(.success(topics.map { TopicModel(title: $0.title ?? "",
                                                            picUrl: $0.picLink ?? "",
                                                            feedUrl: $0.feedUrl ?? "")
                    }))
                } catch let error {
                    single(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func getFeed(by feedUrl: String) -> Maybe<[FeedModel]> {
        return Maybe<[FeedModel]>.create { [persistentContainer] maybe -> Disposable in
            persistentContainer.performBackgroundTask() { context in
                let fetch: NSFetchRequest<Feed> = Feed.fetchRequest()
                fetch.predicate = NSPredicate(format: "topic.feedUrl = %@", feedUrl)
                do {
                    let feed = try fetch.execute()
                    guard !feed.isEmpty else { return maybe(.success([])) }
                    maybe(.success(feed.map { element in
                        let comment = element.comment?.lastObject as? Comment
                        return FeedModel(id: element.id ?? UUID().uuidString,
                                         title: element.title,
                                         pubDate: element.pubDate,
                                         picLinks: element.picLinks ?? [],
                                         description: element.text,
                                         rating: comment?.rating,
                                         comment: comment?.comment)
                    }))
                } catch let error {
                    maybe(.error(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func saveFeed(feedList: [FeedModel], for url: String) -> Single<Void> {
        return Single.create { [persistentContainer] single in
            persistentContainer.performBackgroundTask() { [weak self] context in
                self?.deleteFeed(by: url, with: context)
                let fetch: NSFetchRequest<Topic> = Topic.fetchRequest()
                fetch.predicate = NSPredicate(format: "feedUrl = %@", url)
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
                
                do {
                    try context.save()
                    single(.success(Void()))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    private func deleteFeed(by feedUrl: String, with context: NSManagedObjectContext) {
        let fetch: NSFetchRequest<Comment> = Comment.fetchRequest()
        let comments = try? fetch.execute()
        let feedIds = comments?.compactMap { $0.feed?.id } ?? []
        let ids = Array(Set(feedIds))
        
        let fetchForDelete: NSFetchRequest<NSFetchRequestResult> = Feed.fetchRequest()
        fetchForDelete.predicate = NSPredicate(format: "(topic.feedUrl = %@) AND !(id IN %@)", argumentArray : [feedUrl, ids])
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchForDelete)
        
        _ = try? context.execute(deleteRequest)
        
        context.reset()
    }
    
    func addComment(feedId: String, rating: Double, comment: String) -> Single<Void> {
        return Single.create { [persistentContainer] single in
            persistentContainer.performBackgroundTask() { context in
                let fetch: NSFetchRequest<Feed> = Feed.fetchRequest()
                fetch.predicate = NSPredicate(format: "id = %@", feedId)
                let feed = try? fetch.execute().first
                
                let commentEntity = Comment(context: context)
                commentEntity.comment = comment
                commentEntity.id = UUID().uuidString
                commentEntity.rating = rating
                feed?.addToComment(commentEntity)
                do {
                    try context.save()
                    single(.success(Void()))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
