//
//  RssParser.swift
//  SimpleRss
//
//  Created by Voldem on 11/21/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import Foundation

class XMLParserService {
    func fetchXMLData(for url: String?, withCallback completionHandler: @escaping (_ result: [Feed]?, _ error: Error?) -> Void) {

        let feedList = [Feed(isExpanded: false, title: "IT", pubDate: "https://news.tut.by/rss/it.rss", picUrl: "https://img.tyt.by/n/brushko/0e/9/perseidy_12082017_tutby_brush_phsl_-9131.jpg", description: "asdasddasdasdasdasdasdasd"),
                                Feed(isExpanded: false, title: "IT", pubDate: "https://news.tut.by/rss/it.rss", picUrl: "https://img.tyt.by/n/brushko/0e/9/perseidy_12082017_tutby_brush_phsl_-9131.jpg", description: "asdasddas123123 123123 123123123123 12312312312312312312312312321312dasdasdasdasdasd"),
                                Feed(isExpanded: false, title: "IT", pubDate: "https://news.tut.by/rss/it.rss", picUrl: "https://img.tyt.by/n/brushko/0e/9/perseidy_12082017_tutby_brush_phsl_-9131.jpg", description: "asdasddas123123 123123 123123123123 12312312312312312312312312321312dasdasdasdasdasd")]
        
        completionHandler(feedList, nil)
    }
}
