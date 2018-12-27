//
//  RssService.swift
//  SimpleRss
//
//  Created by Voldem on 12/12/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import Foundation

class RssService: NSObject {
    private struct TagConstants {
        static let item = "item"
        static let link = "url"
        static let title = "title"
        static let pubDate = "pubDate"
        static let description = "description"
        static let mediaDict = "media:content"
        static let close = "/>"
        static let brOpen = "<br"
    }
    
    private struct ErrorConstants {
        static let errorMessage = "Error while parsing"
        static let noHandlerText = "No handler for "
    }
    
    var feedList = [Feed]()
    var feed: Feed?
    var parser: RssParser?
    
    func getFeed(for link: String?, withCallback completionHandler: @escaping(_ result: [Feed]?, _ error: Error?) -> Void) {
        guard let link = link, let url = URL(string: link) else { return }
        parser = RssParser()
        parser?.parse(url) { [weak self] (result, error) in
            guard let strongSelf = self else { completionHandler(nil, nil)
                return }
            result?.forEach({ (key, value) in
                switch key {
                case TagConstants.item:
                    strongSelf.createOrAppendFeed()
                case TagConstants.title:
                    strongSelf.feed?.title = strongSelf.parseAndTrim(value)
                case TagConstants.pubDate:
                    strongSelf.feed?.pubDate = strongSelf.parseAndTrim(value)
                case TagConstants.mediaDict:
                    strongSelf.feed?.picLink = strongSelf.parsePicLink(value)
                case TagConstants.description:
                    strongSelf.feed?.description = strongSelf.parseDescriptionTag(value)
                default:
                    print(ErrorConstants.noHandlerText + key)
                }
            })
            completionHandler (strongSelf.feedList, error)
        }
    }
    
    private func parseDescriptionTag(_ value: Any) -> String? {
        guard let description = value as? String, let beginRange = description.range(of: TagConstants.close), let endRange = description.range(of: TagConstants.brOpen) else { return nil }
        return String(description[beginRange.upperBound..<endRange.lowerBound])
    }
    
    private func createOrAppendFeed() {
        if let _ = feed {
            self.feedList.append(feed!)
            feed = nil
        }
        else {
            feed = Feed()
        }
    }
    
    private func parseAndTrim(_ value: Any) -> String? {
        guard let value = value as? String else { return nil }
        return value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func parsePicLink(_ value: Any) -> String? {
        guard let mediaDict = value as? [String : String] else { return nil }
        return mediaDict[TagConstants.link]
    }
}
