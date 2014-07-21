//
//  WebViewController.swift
//  SwiftSample
//
//  Created by 原田 周作 on 2014/07/20.
//  Copyright (c) 2014年 Shusaku HARADA. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var webBrowser: UIWebView;
    var urlString : NSString = NSString();

    override func viewDidLoad() {
        super.viewDidLoad()

        var barButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "showAlertView:");
        self.navigationItem.setRightBarButtonItem(barButtonItem, animated: true);

        // Do any additional setup after loading the view.
        if (0 < urlString.length) {
            let urlRequest = NSURLRequest(URL: NSURL(string: urlString));
            webBrowser.loadRequest(urlRequest);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func showAlertView(sender: AnyObject!)
    {
        var alertController = UIAlertController(title: "Title", message: "message", preferredStyle: UIAlertControllerStyle.Alert);

        let alertAction: (UIAlertAction!) -> Void = {alertAction in
            if (alertAction.style == UIAlertActionStyle.Cancel) {
                return;
            }
            NSLog("%@", alertAction);
        }
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: alertAction));
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: alertAction));
        
        self.presentViewController(alertController, animated: true, completion: {
            NSLog("show")
            });
    }

    func webViewDidStartLoad(webView: UIWebView!)
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
    }

    func webViewDidFinishLoad(webView: UIWebView!)
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
    }

    func webView(webView: UIWebView!, didFailLoadWithError error: NSError!)
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
    }
}
