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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

