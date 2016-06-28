//
//  SubViewController.swift
//  YomiLog
//
//  Created by wadadon on 2016/06/24.
//  Copyright © 2016年 DAWA. All rights reserved.
//

import Foundation
import UIKit

class SubViewController: UIViewController{
    
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var goodLabel : UILabel!
    @IBOutlet var revewLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        titleLabel.text = sendTitle
        goodLabel.text = String(sendGood)
        revewLabel.text = sendRevew
        print(sendRevew)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}