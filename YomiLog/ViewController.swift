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
        getArticles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func StartButton(sender: AnyObject) {
//        let toJSON: JSON =  ["name": "Jack", "age": 25]
//        print(toJSON)
//        
//        let jsonString = "{\"あああ\": 25}"
//        let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
//        var json = JSON(data: dataFromString!)
//        print(json["あああ"])
        let parameters = [
            "title": "hoge",
            "good": 2,
            "revew": "revew"
        ]
        
        print(parameters)
        Alamofire.request(.POST, "https://yomi-ios-wadadon.c9users.io/new",parameters: parameters,encoding: .JSON)
            .responseString { response in
                if let str = response.result.value{
                    print(str)
                }
        }
        
        getArticles()
    }
    
    func getArticles() {
        Alamofire.request(.GET, "https://yomi-ios-wadadon.c9users.io/show") // APIへリクエストを送信
        .responseJSON { response in
            guard let object = response.result.value else{
                return
            }
            
            print(object)
            if object["title"] != nil{
                print(object["title"]) //idがtitleの要素を取得
            }
            
            
//            let json = JSON(object)
//            json.forEach { (_, json) in
//                print(json["title"].string) // jsonから"title"がキーのものを取得
//            }
            
        }
    }


}

