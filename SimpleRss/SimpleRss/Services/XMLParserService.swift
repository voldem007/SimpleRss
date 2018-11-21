//
//  RssParser.swift
//  SimpleRss
//
//  Created by Voldem on 11/21/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import Foundation

class XMLParserService: NSObject {
    var parser: XMLParser!
    var feedList = [Feed]()
    var feed: Feed?
    var foundElementName: String?
    var error: Error? = nil
    
    func fetchXMLData(for url: String, withCallback completionHandler: @escaping (_ result: [Feed]?, _ error: Error?) -> Void) {
        parser = XMLParser(contentsOf: URL(string: url)!)!
        parser.delegate = self
        
        if parser.parse() {
            if error != nil {
                completionHandler(nil, error)
            }
            else {
                completionHandler(feedList, nil)
            }
        }
        else {
            let newError = NSError(domain:"", code: 400, userInfo: [NSLocalizedDescriptionKey: "Error while parsing"])
            completionHandler(nil, newError)
        }
    }
}

extension XMLParserService: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        foundElementName = elementName
        if elementName == "item" {
            feed = Feed()
            foundElementName = ""
        }
        else if foundElementName == "media:content" {
            feed?.picUrl = attributeDict["url"]!
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if foundElementName == "title" {
            feed?.title.append(string)
        } else if foundElementName == "pubDate" {
            feed?.pubDate.append(string)
        }
        else if foundElementName == "description" {
            feed?.description.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            feedList.append(feed!)
            feed = nil
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
        error = parseError
    }
}

