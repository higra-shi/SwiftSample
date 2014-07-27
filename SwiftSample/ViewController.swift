//
//  ViewController.swift
//  SwiftSample
//
//  Created by 原田 周作 on 2014/06/22.
//  Copyright (c) 2014年 Shusaku HARADA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    enum ViewTags : Int
    {
        case RssTableView = 100
        case LoadingView
    }

    var rssData: NSMutableArray = NSMutableArray();
    let CellIdentifier = "CellIdentifier";

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Main";

        var viewFrame: CGRect = self.view.frame;
        viewFrame.origin = CGPointZero;

        let tableView = UITableView(frame: viewFrame, style: UITableViewStyle.Plain);
        tableView.tag = ViewTags.RssTableView.toRaw();
        tableView.backgroundColor = UIColor(white: 0.0, alpha: 0.0);
        tableView.autoresizingMask = self.view.autoresizingMask;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier);
        self.view.addSubview(tableView);

        loadRssData(nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Load RSS Data
    func hideLoadingView()
    {
        let loadingView = self.view.viewWithTag(ViewTags.LoadingView.toRaw());
        if (loadingView) {
            loadingView.removeFromSuperview();
        }
    }

    func showLoadinView()
    {
        hideLoadingView();

        var viewFrame: CGRect = self.view.frame;
        viewFrame.origin = CGPointZero;

        let loadingView :UIView = UIView(frame: viewFrame);
        loadingView.tag = ViewTags.LoadingView.toRaw();
        loadingView.backgroundColor = UIColor(white: 0.5, alpha: 1.0);

        viewFrame.origin.x = floor((viewFrame.size.width / 2));
        viewFrame.origin.y = floor((viewFrame.size.height / 2));
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge);
        indicatorView.backgroundColor = UIColor(white: 0.0, alpha: 0.0);
        indicatorView.center = viewFrame.origin;
        indicatorView.startAnimating();
        loadingView.addSubview(indicatorView);
        
        self.view.addSubview(loadingView);
    }

    func loadRssData(sender: AnyObject!)
    {
        showLoadinView();

        NSLog("loading rss data...");
        let nc = NSNotificationCenter.defaultCenter();
        nc.addObserver(self, selector: "didLoadRssData:", name: NetworkManagerRequestSuccess, object: nil);
        nc.addObserver(self, selector: "didLoadRssData:", name: NetworkManagerRequestFailed, object: nil);
        
        let manager = CommonNetworkManager();
        manager.requestWithUrl("http://rss.dailynews.yahoo.co.jp/fc/rss.xml");
    }

    func didLoadRssData(notification: NSNotification)
    {
        hideLoadingView();

        NSLog("notification: %@", notification.name);
        if (NetworkManagerRequestFailed.isEqualToString(notification.name)) {
            return;
        }

        let receivedData = (notification.object as NSData);
        let parse = RSSParser();
        parse.parseWtihRssData(receivedData);

        NSLog("%@", NSString(data: receivedData, encoding: NSUTF8StringEncoding));
        NSLog("%@", parse.rssData);

        rssData = NSMutableArray(array: parse.rssData);
        (self.view.viewWithTag(ViewTags.RssTableView.toRaw()) as UITableView).reloadData();
    }
}

// MARK: - Table view data source

extension ViewController : UITableViewDataSource {

    func tableView(tableView:UITableView!, numberOfRowsInSection section:Int) -> Int {
        return rssData.count;
    }
    
    func tableView(tableView:UITableView!, cellForRowAtIndexPath indexPath:NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: CellIdentifier)

        let rssItem: NSDictionary = rssData[indexPath.row] as NSDictionary;
        cell.textLabel.text = rssItem[RssElementTitle] as String;
        
        return cell
    }
}

// MARK: - Table view delegate

extension ViewController : UITableViewDelegate {

    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        let rssItem: NSDictionary = rssData[indexPath.row] as NSDictionary;
        let urlString = rssItem[RssElementLinkUrl] as NSString;

        var vc = WebViewController(coder: nil);
        vc.urlString = urlString;
        vc.title = rssItem[RssElementTitle] as NSString;
        self.navigationController.pushViewController(vc, animated: true);
    }
}



