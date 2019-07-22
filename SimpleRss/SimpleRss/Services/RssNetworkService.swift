//
//  RssNetworkService
//  SimpleRss
//
//  Created by Voldem on 12/12/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import Foundation
import RxSwift

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
    
    lazy var parser: RssParser = RssParser()
    
    func getFeed(for url: URL) -> Single<[FeedModel]> {
        return Single<[FeedModel]>.create { [weak parser] single in
            parser?.parse(url) { [weak self] (result, error) in
                guard let self = self else { return }
                var feed: FeedModel?
                var feedList = [FeedModel]()
                result?.forEach { (key, value) in
                    switch key {
                    case TagConstants.item:
                        feed = self.createOrAppendFeed(feed: feed, append: { feedList.append($0) })
                    case TagConstants.title:
                        feed?.title = self.parseAndTrim(value)
                    case TagConstants.guid:
                        feed?.guid = self.parseAndTrim(value) ?? UUID().uuidString
                    case TagConstants.pubDate:
                        feed?.pubDate = self.parseAndTrim(value)
                    case TagConstants.mediaDict:
                        feed?.picLink = self.parsePicLink(value)
                    case TagConstants.description:
                        feed?.description = self.parseDescriptionTag(value)
                    default:
                        print(ErrorConstants.noHandlerText + key)
                    }
                }
                if let er = error {
                    single(.error(er))
                }
                single(.success(feedList))
            }
            
            return Disposables.create()
        }
    }
    
    private func parseDescriptionTag(_ value: Any) -> String? {
        guard let description = value as? String, let beginRange = description.range(of: TagConstants.close), let endRange = description.range(of: TagConstants.brOpen) else { return nil }
        return String(description[beginRange.upperBound..<endRange.lowerBound])
    }
    
    private func createOrAppendFeed(feed: FeedModel?, append: (FeedModel) -> Void) -> FeedModel? {
        if let f = feed {
            append(f)
            return nil
        }
        else {
            return FeedModel()
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
