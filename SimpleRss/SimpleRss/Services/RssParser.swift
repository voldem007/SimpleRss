//
//  RssParser.swift
//  SimpleRss
//
//  Created by Voldem on 11/21/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import Foundation

class RssParser: NSObject {
    private struct Constants {
        static let errorMessage = "Error while parsing"
        static let errorCode = 400
    }
    
    var attributeValue = ""
    var attributeDict: [String : String]?
    var prevElementName = ""
    var wasElementClosed = true
    var rssDictionary = [(String, Any)]()
    var error: Error? = nil
    
    func parse(_ url: URL, withCallback completionHandler: @escaping(_ result: [(String, Any)]?, _ error: Error?) -> Void) {
        let parser = XMLParser(contentsOf: url)
        parser?.delegate = self
        if let _ = parser?.parse() {
            if error != nil {
                completionHandler(nil, error)
            }
            else {
                completionHandler(rssDictionary, nil)
            }
        }
        else {
            let newError = NSError(domain:"", code: Constants.errorCode, userInfo: [NSLocalizedDescriptionKey: Constants.errorMessage])
            completionHandler(nil, newError)
        }
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
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        error = parseError
    }
}
