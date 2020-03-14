//
//  RssParser.swift
//  SimpleRss
//
//  Created by Voldem on 11/21/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import Foundation

protocol Parser {
    func parse(_ url: URL, completion: @escaping([(String, Any)]?, Error?) -> Void)
}

final class RssParser: NSObject, Parser {
    private var attributeValue = ""
    private var attributeDict: [String : String]?
    private var prevElementName = ""
    private var wasElementClosed = true
    private var rssDictionary = [(String, Any)]()
    private var completionHandler: (([(String, Any)]?, Error?) -> Void)?
    
    private let network: Network
    
    init(network: Network = Networking()) {
        self.network = network
    }
    
    func parse(_ url: URL, completion: @escaping([(String, Any)]?, Error?) -> Void) {
        rssDictionary = [(String, Any)]()
        completionHandler = completion
        network.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { completion(nil, error)
                return
            }
            if error != nil {
                completion(nil, error)
                return
            }
            
            guard let data = data else { completion(nil, nil)
                return }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
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
    
    func parserDidEndDocument(_ parser: XMLParser) {
        completionHandler?(rssDictionary, parser.parserError)
    }
}
