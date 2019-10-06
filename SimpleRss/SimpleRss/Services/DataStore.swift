//
//  DataStore.swift
//  SimpleRss
//
//  Created by Voldem on 10/6/19.
//  Copyright © 2019 Vladimir Koptev. All rights reserved.
//

import Foundation
import CoreData

class DataStore {
    
    /// The URL of the sqlite file.
    private var sqliteURL: URL {
        return storageURL.appendingPathComponent("rss").appendingPathExtension("sqlite")
    }
    
    /// The directory in which the store files will be saved
    private var storageURL: URL {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("The user's document directory does not exist.")
        }
        
        return documentsURL
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let url = sqliteURL
        let container = NSPersistentContainer(name: "rss")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            guard let loadError = error else {
                // success
                return
            }
            
            // remove store that cannot be loaded
            try? container.persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: NSSQLiteStoreType, options: nil)
            
            // load again now that previous store has been removed
            container.loadPersistentStores { _, error in
                if let error = error as NSError? {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
        })
        return container
    }()
    
    func preloadDataIfFirstLaunch() {
        let defaults = UserDefaults.standard
        let isPreloaded = defaults.bool(forKey: "isPreloaded")
        if !isPreloaded {
            preloadData()
            defaults.set(true, forKey: "isPreloaded")
        }
    }
    
    private func preloadData() {
        let topics: [TopicModel] = [TopicModel(title: "IT", picUrl: "https://img.tyt.by/n/brushko/0e/9/perseidy_12082017_tutby_brush_phsl_-9131.jpg", feedUrl: "https://news.tut.by/rss/it.rss"),
                                    TopicModel(title: "Economics", picUrl: "https://img.tyt.by/n/01/a/mid_belarusi_st.jpg", feedUrl: "https://news.tut.by/rss/economics.rss"),
                                    TopicModel(title: "Politics", picUrl: "https://img.tyt.by/n/it/0f/7/world-of-tanks.jpg", feedUrl: "https://www.hltv.org/rss/news")]
        
        let managedObjectContext = persistentContainer.viewContext
        
        topics.forEach({ topicModel in
            let topic = NSEntityDescription.insertNewObject(forEntityName: "Topic", into: managedObjectContext) as! Topic
            
            topic.title = topicModel.title
            topic.picLink = topicModel.picUrl
            topic.feedUrl = topicModel.feedUrl
            try? managedObjectContext.save()
        })
    }
}
