//
//  ViewController.swift
//  YomiLog
//
//  Created by wadadon on 2016/06/19.
//  Copyright © 2016年 DAWA. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //getArticles()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        getArticles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func StartButton(sender: AnyObject) {
        
        let parameters = [
            "title": "foo",
            "good": 2,
            "revew": "bar"
        ]
        
        print(parameters)

        Alamofire.request(.POST, "https://yomi-ios-wadadon.c9users.io/new",parameters: parameters, encoding: .JSON)
            .responseString{ Error in
                print(Error)
        }
        
        getArticles()
    }
    
    func getArticles() {
        Alamofire.request(.GET, "https://yomi-ios-wadadon.c9users.io/show") // APIへリクエストを送信
        .responseJSON { response in
            guard let object = response.result.value else{
                return
            }
            
            let jsonObject = JSON(object)
            jsonObject.forEach{(_, jsonObject) in
                let title = jsonObject["title"].string
                
                if title != nil{
                    print(title) //idがtitleの要素を取得
                }
            }
            
            
        }
    }


}

