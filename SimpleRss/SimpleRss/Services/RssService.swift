//
//  RssService.swift
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
                    if let _ = feed {
                        self.feedList.append(feed!)
                        feed = nil
                    }
                    else {
                        feed = Feed()
                    }
                case Constants.titleTag:
                    if let title = value as? String {
                        feed?.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                case Constants.pubDateTag:
                    if let pubDate = value as? String {
                        feed?.pubDate = pubDate.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                case Constants.picUrlTag:
                    if let picUrlTag = value as? [String : String] {
                        feed?.picUrl = picUrlTag[Constants.urlTag]
                    }
                case Constants.descriptionTag:
                    if let description = value as? String {
                        guard let beginRange = description.range(of: "/>") else { return }
                        guard let endRange = description.range(of: "<br") else { return }
                        let substring = description[beginRange.upperBound..<endRange.lowerBound]
                        feed?.description = String(substring)
                    }
                default:
                    print("No items")
                }
            })
            
            completionHandler(self.feedList, error)
        }
    }
}
