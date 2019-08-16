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
    
    private enum RssError: Error {
        case noData
    }
    
    lazy var parser: RssParser = RssParser()
    
    func getFeed(for url: URL) -> Single<[FeedModel]> {
        return Single<[FeedModel]>.create { [parser] single in
            parser.parse(url) { (result, error) in
                guard let rawXml = result else {
                    single(.error(error ?? RssError.noData))
                    return
                }
                single(.success(FeedModel.from(rawXml)))
            }
            
            return Disposables.create()
        }
    }
    
}

private extension FeedModel {
    
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
    
    static func from(_ raw: [(String, Any)]) -> [FeedModel] {
        func tryParsingStringValue(_ value: Any, defaultValue: String? = nil) -> String? {
            guard let value = value as? String else { return defaultValue }
            return value.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        func tryParsingImageLinkValue(_ value: Any) -> String? {
            guard let mediaDict = value as? [String : String] else { return nil }
            return mediaDict[TagConstants.link]
        }
        
        func tryParsingDescriptionValue(_ value: Any) -> String? {
            guard let description = value as? String,
                let beginRange = description.range(of: TagConstants.close),
                let endRange = description.range(of: TagConstants.brOpen) else { return nil }
            return String(description[beginRange.upperBound..<endRange.lowerBound])
        }
        
        var current: FeedModel?
        var result = [FeedModel]()
        for (key, value) in raw {
            switch key {
            case TagConstants.item:
                if let feed = current {
                    result.append(feed)
                    current = nil
                } else {
                    current = FeedModel()
                }
            case TagConstants.title:
                current?.title = tryParsingStringValue(value)
            case TagConstants.guid:
                current?.guid = tryParsingStringValue(value, defaultValue: UUID().uuidString)!
            case TagConstants.pubDate:
                current?.pubDate = tryParsingStringValue(value)
            case TagConstants.mediaDict:
                current?.picLink = tryParsingImageLinkValue(value)
            case TagConstants.description:
                current?.description = tryParsingDescriptionValue(value)
            default:
                print("No handler for '\(key)'")
            }
        }
        return result
    }
}
