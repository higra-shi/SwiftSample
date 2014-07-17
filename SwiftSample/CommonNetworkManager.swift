//
//  CommonNetworkManager.swift
//  SwiftSample
//
//  Created by 原田　周作 on 2014/07/17.
//  Copyright (c) 2014年 Shusaku HARADA. All rights reserved.
//

import UIKit

let NetworkManagerRequestSuccess: NSString = "requestSuccess";
let NetworkManagerRequestFailed: NSString = "requestFailed";

class CommonNetworkManager: NSObject {

    class CommonNetworkManagerPrivate: NSObject, NSURLConnectionDataDelegate
    {
        var receivedData: NSMutableData = NSMutableData();
        
        func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!)
        {
            if ((response as NSHTTPURLResponse).statusCode != 200) {
                NSNotificationCenter.defaultCenter().postNotificationName(NetworkManagerRequestFailed, object: nil);
            }
            
            receivedData.length = 0;
        }
        
        func connection(connection: NSURLConnection!, didReceiveData data: NSData!)
        {
            receivedData.appendData(data);
        }
        
        func connectionDidFinishLoading(connection: NSURLConnection!)
        {
            NSNotificationCenter.defaultCenter().postNotificationName(NetworkManagerRequestSuccess, object: receivedData);
        }
        
        func connection(connection: NSURLConnection!, didFailWithError error: NSError!)
        {
            NSLog("request failed. %@", error);
            NSNotificationCenter.defaultCenter().postNotificationName(NetworkManagerRequestFailed, object: nil);
        }
    }

    func requestWithUrl(urlString :NSString) {
        NSLog("request to %@", urlString);

        let urlRequest = NSURLRequest(URL: NSURL(string: urlString));
        let urlConnection = NSURLConnection(request: urlRequest, delegate: CommonNetworkManagerPrivate());
    }
}
