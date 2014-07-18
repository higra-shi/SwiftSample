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
        let elementNameItem: NSString = "item";
        let elementNamePubDate: NSString = "pubDate";

        var rssData: NSMutableArray = NSMutableArray();
        var itemData: NSMutableDictionary = NSMutableDictionary();
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
            if (elementNameItem.isEqualToString(elementName)) {
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
            if (elementNameItem.isEqualToString(elementName)) {
                rssData.addObject(NSDictionary(dictionary: itemData));
                itemData.removeAllObjects();
                isItemElement = false;
            }
            else if (isItemElement) {
                if (elementNamePubDate.isEqualToString(elementName)) {
                    var formatter = NSDateFormatter();
                    formatter.calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar);
                    formatter.locale = NSLocale(localeIdentifier: "en_US");
                    formatter.timeZone = NSTimeZone.systemTimeZone();
                    formatter.dateFormat = "EEE, d LLL yyyy HH:mm:ss Z"
                    var pubDate = formatter.dateFromString(elementValue);
                    if (pubDate) {
                        itemData.setValue(pubDate, forKey: elementName);
                    }
                }
                else {
                    itemData.setValue(elementValue, forKey: elementName);
                }
            }
        }

        func parser(parser: NSXMLParser!, foundCharacters string: String!)
        {
            NSLog("Characters: %@", string);
            elementValue = string;
        }

        func sortedRssData() -> NSArray
        {
            rssData.sortUsingComparator({source, target in
                var sourceDate = source.objectForKey(self.elementNamePubDate) as NSDate;
                var targetDate = target.objectForKey(self.elementNamePubDate) as NSDate;
                return targetDate.compare(sourceDate);
                });
            return NSArray(array: rssData);
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
        rssData.addObjectsFromArray(private.rssData);
    }
}
