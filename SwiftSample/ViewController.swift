//
//  ViewController.swift
//  SwiftSample
//
//  Created by 原田 周作 on 2014/06/22.
//  Copyright (c) 2014年 Shusaku HARADA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Main";

        var viewFrame: CGRect = self.view.frame;

        viewFrame.origin = CGPointZero;
        viewFrame.size.height = 128;
        var textLabel: UILabel = UILabel(frame: viewFrame);
        textLabel.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5);
        textLabel.autoresizingMask = UIViewAutoresizing.FlexibleWidth;
        self.view.addSubview(textLabel);

        viewFrame.origin.y += viewFrame.size.height + 8;
        textLabel = UILabel(frame: viewFrame);
        textLabel.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5);
        self.view.addSubview(textLabel);

        var myVariable: NSInteger = 42
        myVariable = 50;
        let myConstant = 60
        // myConstant = 9

        var cities = ["Tokyo", "Osaka", "Sendai"]
        cities[2] = "Nagoya"
        cities.append("Kyoto")

        var scores = ["A":32, "B":76, "C":54]
        scores["A"] = 82
        scores["D"] = 76

        for (var i = 0; i < cities.count; i++) {
            println(cities[i]);
        }
        
        for (name, score) in scores {
            println("Name : \(name) -> \(score)");
        }

        var i = 0;
        while (i < cities.count) {
            println("City: "+cities[i]);
            i++;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func tappedButton(sender: UIButton?)
    {
//        var vc: AnyObject! = self.navigationController.storyboard.instantiateViewControllerWithIdentifier("SubView");
//        if (vc.isKindOfClass(UIViewController)) {
//            self.navigationController.pushViewController(vc as UIViewController, animated: true);
//        }

        let nc = NSNotificationCenter.defaultCenter();
        nc.addObserver(self, selector: "didLoadRssData:", name: NetworkManagerRequestSuccess, object: nil);
        nc.addObserver(self, selector: "didLoadRssData:", name: NetworkManagerRequestFailed, object: nil);

        let manager = CommonNetworkManager();
        manager.requestWithUrl("http://rss.dailynews.yahoo.co.jp/fc/rss.xml");
    }

    func didLoadRssData(notification: NSNotification)
    {
        NSLog("notification: %@", notification.name);
        if (NetworkManagerRequestFailed.isEqualToString(notification.name)) {
            return;
        }

        let receivedData = (notification.object as NSData);
        let parse = RSSParser();
        parse.parseWtihRssData(receivedData);

        NSLog("%@", NSString(data: receivedData, encoding: NSUTF8StringEncoding));
        NSLog("%@", parse.rssData);
    }
}

