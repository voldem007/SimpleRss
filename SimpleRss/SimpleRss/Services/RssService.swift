//
//  File.swift
//  SimpleRss
//
//  Created by Voldem on 12/12/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import Foundation

class RssService: NSObject {
    private struct Constants {
        static let errorMessage = "Error while parsing"
        static let itemTag = "item"
        static let urlTag = "url"
        static let titleTag = "title"
        static let pubDateTag = "pubDate"
        static let descriptionTag = "description"
        static let picUrlTag = "media:content"
    }
    
    var feedList = [Feed]()
    
    func getFeed(for link: String?, withCallback completionHandler: @escaping (_ result: [Feed]?, _ error: Error?) -> Void) {
        guard let link = link, let url = URL(string: link) else { return }
        let parser = RssParser()
        var feed: Feed?
        parser.parse(url) { (result, error) in //[weak self]
            result?.map({ (key, value) in
                switch key {
                    case Constants.itemTag:
                        if feed == nil {
                            feed = Feed(title: "asd", pubDate: "asddd", picUrl: "asdd", description: "dddd")
                        }
                        else {
                            self.feedList.append(feed!)
                            feed = nil
                        }
                    //case value 2,
                    //value 3:
                    //respond to value 2 or 3
                    default:
                        print("No items")
                    //otherwise, do something else
                }
            })
            
            completionHandler(self.feedList, error)
        }
        /*
         completionHandler(nil, error)
         completionHandler(feedList, nil)
         completionHandler(nil, newError)
         */
        
        //foundElementName = elementName
        //if elementName == Constants.itemTag {
        //feed = Feed()
        //}
        //else if foundElementName == Constants.picUrlTag {
        //  feed?.picUrl = attributeDict[Constants.urlTag]!
        //}
        
        //if elementName == Constants.itemTag {
        
        //  guard let beginRange = feed?.description.range(of: "/>"), let feed = feed else { return }
        //  guard let endRange = feed.description.range(of: "<br") else { return }
        //let substring = feed.description[beginRange.upperBound..<endRange.lowerBound]
        // feed.description = String(substring)
        
        // feed.title = feed.title.trimmingCharacters(in: .whitespacesAndNewlines)
        // feed.pubDate = feed.pubDate.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // feedList.append(feed)
        // }
        
        // if foundElementName == Constants.titleTag {
        // feed?.title.append(string)
        //} else if foundElementName == Constants.pubDateTag {
        // feed?.pubDate.append(string)
        //}
        //else if foundElementName == Constants.descriptionTag {
        // feed?.description.append(string)
        //}
    }
}

