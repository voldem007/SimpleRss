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
        static let linkTag = "url"
        static let titleTag = "title"
        static let pubDateTag = "pubDate"
        static let descriptionTag = "description"
        static let mediaDictTag = "media:content"
        static let closeTag = "/>"
        static let brOpenTag = "<br"
        static let noHandlerText = "No handler for "
    }
    
    var feedList = [Feed]()
    var feed: Feed?
    
    func getFeed(for link: String?, withCallback completionHandler: @escaping (_ result: [Feed]?, _ error: Error?) -> Void) {
        guard let link = link, let url = URL(string: link) else { return }
        let parser = RssParser()
        parser.parse(url) { [weak self] (result, error) in
            result?.map({ (key, value) in
                switch key {
                case Constants.itemTag:
                    createOrAppendFeed()
                case Constants.titleTag:
                    self?.feed?.title = parseAndTrim(value)
                case Constants.pubDateTag:
                    self?.feed?.pubDate = parseAndTrim(value)
                case Constants.mediaDictTag:
                    self?.feed?.picLink = parsePicLink(value)
                case Constants.descriptionTag:
                    self?.feed?.description = parseDescriptionTag(value)
                default:
                    print(Constants.noHandlerText + key)
                }
            })
            
            completionHandler(self?.feedList, error)
        }
        
        func parseDescriptionTag(_ value: Any) -> String {
            guard let description = value as? String else { return "" }
            guard let beginRange = description.range(of: Constants.closeTag) else { return "" }
            guard let endRange = description.range(of: Constants.brOpenTag) else { return "" }
            return String(description[beginRange.upperBound..<endRange.lowerBound])
        }
        
        func createOrAppendFeed() {
            if let _ = feed {
                self.feedList.append(feed!)
                feed = nil
            }
            else {
                feed = Feed()
            }
        }
        
        func parseAndTrim(_ value: Any) -> String {
            guard let value = value as? String else { return "" }
            return value.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        func parsePicLink(_ value: Any) -> String {
            guard let mediaDict = value as? [String : String] else { return "" }
            return mediaDict[Constants.linkTag] ?? ""
        }
    }
}
