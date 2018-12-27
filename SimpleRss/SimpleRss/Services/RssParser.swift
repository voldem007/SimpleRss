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
    var parser: XMLParser?
    var isSuccess: Bool?
    
    func parse(_ url: URL, withCallback completionHandler: @escaping(_ result: [(String, Any)]?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let `self` = self else { return }
            if error != nil {
                completionHandler(nil, error)
            }
            
            guard let `data` = data else { return }
            self.parser = XMLParser(data: data)
            self.parser?.delegate = self
            self.isSuccess = self.parser?.parse()
            DispatchQueue.main.async {
                if let _ = self.isSuccess {
                    if self.error != nil {
                        completionHandler(nil, self.error)
                    }
                    else {
                        completionHandler(self.rssDictionary, nil)
                    }
                }
                else {
                    let newError = NSError(domain:"", code: Constants.errorCode, userInfo: [NSLocalizedDescriptionKey: Constants.errorMessage])
                    completionHandler(nil, newError)
                }
            }
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
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        error = parseError
    }
}
