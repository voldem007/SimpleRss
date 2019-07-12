//
//  RssNetworkService
//  SimpleRss
//
//  Created by Voldem on 12/12/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import Foundation

final class RssNetworkService: NetworkService {
    
    private struct TagConstants {
        static let item = "item"
        static let guid = "guid"
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
    
    var feedList = [FeedModel]()
    var feed: FeedModel?
    lazy var parser: RssParser = RssParser()
    
    func getFeed(for link: String?, withCallback completionHandler: @escaping(_ result: [FeedModel]?, _ error: Error?) -> Void) {
        feedList = [FeedModel]()
        guard let link = link, let url = URL(string: link) else { return }
        parser.parse(url) { [weak self] (result, error) in
            guard let self = self else { completionHandler(nil, nil)
                return }
            result?.forEach({ (key, value) in
                switch key {
                case TagConstants.item:
                    self.createOrAppendFeed()
                case TagConstants.title:
                    self.feed?.title = self.parseAndTrim(value)
                case TagConstants.guid:
                    self.feed?.guid = self.parseAndTrim(value) ?? UUID().uuidString
                case TagConstants.pubDate:
                    self.feed?.pubDate = self.parseAndTrim(value)
                case TagConstants.mediaDict:
                    self.feed?.picLink = self.parsePicLink(value)
                case TagConstants.description:
                    self.feed?.description = self.parseDescriptionTag(value)
                default:
                    print(ErrorConstants.noHandlerText + key)
                }
            })
            completionHandler (self.feedList, error)
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
            feed = FeedModel()
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
