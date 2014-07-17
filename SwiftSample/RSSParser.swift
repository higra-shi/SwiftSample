//
//  RSSParser.swift
//  SwiftSample
//
//  Created by 原田　周作 on 2014/07/17.
//  Copyright (c) 2014年 Shusaku HARADA. All rights reserved.
//

import UIKit

class RSSParser: NSObject {
    var rssData: NSMutableArray = NSMutableArray();

    class RSSParserPrivate : NSObject, NSXMLParserDelegate {
        var rssData: NSMutableArray = NSMutableArray();
        var itemData: NSMutableDictionary = NSMutableDictionary();
        let itemElementName: NSString = "item";
        var isItemElement = false;
        var elementValue: NSString = NSString();
        var attributeData: NSMutableDictionary = NSMutableDictionary();

        init()
        {
            rssData.removeAllObjects();
            itemData.removeAllObjects();
            isItemElement = false;
        }

        func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!)
        {
            NSLog("start\t element: %@", elementName);
            NSLog("%@", attributeDict);
            if (itemElementName.isEqualToString(elementName)) {
                isItemElement = true;
            }
            else if (!isItemElement) {
                return;
            }
            else if (0 < attributeDict.count) {
                itemData.setObject(attributeDict, forKey: elementName+"AttributeData");
            }
        }
        
        func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!)
        {
            NSLog("end\t element: %@", elementName);
            if (itemElementName.isEqualToString(elementName)) {
                rssData.addObject(NSDictionary(dictionary: itemData));
                itemData.removeAllObjects();
                isItemElement = false;
            }
            else if (isItemElement) {
                itemData.setValue(elementValue, forKey: elementName);
            }
        }

        func parser(parser: NSXMLParser!, foundCharacters string: String!)
        {
            NSLog("Characters: %@", string);
            elementValue = string;
        }
    }

    init()
    {
        rssData.removeAllObjects();
    }

    func parseWtihRssData(data: NSData)
    {
        let private = RSSParserPrivate();

        var xmlParser = NSXMLParser(data: data);
        xmlParser.delegate = private;
        if (!xmlParser.parse()) {
            NSLog("error on rss parsing");
        }
        else {
            NSLog("rss parse is success");
        }
        rssData = private.rssData;
    }
}
