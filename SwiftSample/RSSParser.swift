//
//  RSSParser.swift
//  SwiftSample
//
//  Created by 原田　周作 on 2014/07/17.
//  Copyright (c) 2014年 Shusaku HARADA. All rights reserved.
//

import UIKit

let RssElementItem: NSString = "item";
let RssElementPublishedDate: NSString = "pubDate";
let RssElementTitle: NSString = "title";
let RssElementLinkUrl: NSString = "link";

class RSSParser: NSObject {
    var rssData: NSMutableArray = NSMutableArray();

    class RSSParserPrivate : NSObject, NSXMLParserDelegate {

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
            if (RssElementItem.isEqualToString(elementName)) {
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
            if (RssElementItem.isEqualToString(elementName)) {
                rssData.addObject(NSDictionary(dictionary: itemData));
                itemData.removeAllObjects();
                isItemElement = false;
            }
            else if (isItemElement) {
                if (RssElementPublishedDate.isEqualToString(elementName)) {
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
                var sourceDate = source.objectForKey(RssElementPublishedDate) as NSDate;
                var targetDate = target.objectForKey(RssElementPublishedDate) as NSDate;
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
        let privateObject = RSSParserPrivate();

        var xmlParser = NSXMLParser(data: data);
        xmlParser.delegate = privateObject;
        if (!xmlParser.parse()) {
            NSLog("error on rss parsing");
        }
        else {
            NSLog("rss parse is success");
        }
        rssData.addObjectsFromArray(privateObject.rssData);
    }
}
