//
//  RssParser.swift
//  SimpleRss
//
//  Created by Voldem on 11/21/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import Foundation

class RssParser: NSObject {
    var attributeValue = ""
    var attributeDict: [String : String]?
    var prevElementName = ""
    var wasElementClosed = true
    var rssDictionary = [(String, Any)]()
    
    func parse(_ url: URL, withCallback completionHandler: @escaping(_ result: [(String, Any)]?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let strongSelf = self else { completionHandler(nil, error)
                return
            }
            if error != nil {
                completionHandler(nil, error)
                return
            }
            
            guard let `data` = data else { completionHandler(nil, nil)
                return }
            
            let parser = XMLParser(data: data)
            parser.delegate = strongSelf
            
            parser.parse()
            completionHandler(strongSelf.rssDictionary, parser.parserError)
        }.resume()
    }
}

extension RssParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if !attributeDict.isEmpty {
            self.attributeDict = attributeDict
        }
        
        if(!wasElementClosed) {
            rssDictionary.append((prevElementName, ""))
        }
        
        prevElementName = elementName
        wasElementClosed = false
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        attributeValue.append(string)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        rssDictionary.append((elementName, attributeDict ?? attributeValue))
        attributeValue = ""
        attributeDict = nil
        wasElementClosed = true
    }
}
