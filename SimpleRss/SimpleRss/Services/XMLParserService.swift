//
//  RssParser.swift
//  SimpleRss
//
//  Created by Voldem on 11/21/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import Foundation

class XMLParserService: NSObject {
    func fetchXMLData(for link: String, withCallback completionHandler: @escaping (_ result: [Feed]) -> Void) {
        
        let feedList = [Feed(title: "IT", pubDate: "https://news.tut.by/rss/it.rss", picUrl: "https://img.tyt.by/n/brushko/0e/9/perseidy_12082017_tutby_brush_phsl_-9131.jpg", description: "asdasddasdasdasdasdasdasd"),
                        Feed(title: "IT", pubDate: "https://news.tut.by/rss/it.rss", picUrl: "https://img.tyt.by/n/brushko/0e/9/perseidy_12082017_tutby_brush_phsl_-9131.jpg", description: "asdasddas123123 123123 123123123123 12312312312312312312312312321312dasdasdasdasdasd"),
                        Feed(title: "IT", pubDate: "https://news.tut.by/rss/it.rss", picUrl: "https://img.tyt.by/n/brushko/0e/9/perseidy_12082017_tutby_brush_phsl_-9131.jpg", description: "asdasddas123123 123123 123123123123 12312312312312312312312312321312dasdasdasdasdasd")]
        
        completionHandler(feedList)
    }
}
