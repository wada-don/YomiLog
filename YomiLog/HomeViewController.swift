//
//  HomeViewController.swift
//  YomiLog
//
//  Created by wadadon on 2016/06/24.
//  Copyright © 2016年 DAWA. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import SCLAlertView
import SwiftSpinner


var sendTitle = ""
var sendGood = 0
var sendRevew = ""

var setGood = 0

class HomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ENSideMenuDelegate{
    
    @IBOutlet var table : UITableView!
    var tableCount: Int = 0
    var tableTitleArray = [""]
    var tableGoodArray:[Int] = []
    var tableRevewArray = [""]
    var newTitle = "";
    var newGood = 0;
    var newRevew = "";
    var didLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.backgroundColor = UIColor.whiteColor()
        self.sideMenuController()?.sideMenu?.delegate = self
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if(didLoad == false){
            SwiftSpinner.show("Connecting")
            tableTitleArray.removeAll()
            tableRevewArray.removeAll()
            tableGoodArray.removeAll()
            getArticles()
            SwiftSpinner.hide()
            
            didLoad = true
        }
        
        if let indexPathForSelectedRow = table.indexPathForSelectedRow {
            table.deselectRowAtIndexPath(indexPathForSelectedRow, animated: true)
        }
    }
    
    //Table Viewのセルの数を指定
    func tableView(table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableCount
    }
    
    //各セルの要素を設定する
    func tableView(table: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        // tableCell の ID で UITableViewCell のインスタンスを生成
        let cell = table.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath)
        
        let titleLabel = table.viewWithTag(1) as! UILabel
        titleLabel.text = tableTitleArray[indexPath.row]
        titleLabel.textColor = UIColor(red:164/255, green:41/255, blue:255/255, alpha:1.0)
        
        let goodLabel = table.viewWithTag(2) as! UILabel
        goodLabel.text = "評価 : " + String(tableGoodArray[indexPath.row])
        goodLabel.textColor = UIColor(red:164/255, green:41/255, blue:255/255, alpha:1.0)
        
        return cell
    }
    
    // Cell が選択された場合
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        sendTitle = tableTitleArray[indexPath.row]
        sendGood = tableGoodArray[indexPath.row]
        sendRevew = tableRevewArray[indexPath.row]
        self.performSegueWithIdentifier("toSubViewController", sender: self)
    }
    
    @IBAction func createLog(){
        showAlert()
    }
    
    
    func getArticles() {
        
        tableTitleArray.removeAll()
        tableRevewArray.removeAll()
        tableGoodArray.removeAll()
        
        //setGoodの値によってパラメータを生成してサーバー側で条件分岐、goodの検索をかけてレスポンスを送る
        
        
        let parameters:[String:AnyObject] = [
            "goodCount": setGood
        ]
        
        print(parameters)
        
        Alamofire.request(.GET, "https://yomi-ios-wadadon.c9users.io/show") // APIへリクエストを送信
            
            .responseString{ Error in
                print(Error)
            }
            .responseJSON { response in
                guard let object = response.result.value else{
                    return
                }
                
                
                self.tableCount = object.count
                let jsonObject = JSON(object)
                
                print(jsonObject)
                
                jsonObject.forEach{(_, jsonObject) in
                    let title = jsonObject["title"].string
                    let good = jsonObject["good"].int
                    let revew = jsonObject["revew"].string
                    
                    
                    if title != nil {
                        self.tableTitleArray.append(title!)
                    }else{
                        self.tableTitleArray.append("")
                    }
                    
                    if good != nil {
                        self.tableGoodArray.append(good!)
                    }else{
                        self.tableGoodArray.append(0)
                    }
                    
                    if revew != nil {
                        self.tableRevewArray.append(revew!)
                    }else{
                        self.tableRevewArray.append("")
                    }
                    
                }
                
                self.table.reloadData()
                
        }
        
    }
    
    func showAlert(){
        let alert = SCLAlertView()
        let title = alert.addTextField("タイトル")
        let good = alert.addTextField("評価(1〜5)")
        let revew = alert.addTextField("ひとことレビュー")
        alert.addButton("Done"){
            if(title.text != "" && good.text != "" && revew.text != ""){
                print(title.text)
                print(good.text)
                print(revew.text)
                self.newTitle = title.text!
                self.newGood = Int(good.text!)!
                self.newRevew = revew.text!
                
                self.postReqest()
            }
        }
        alert.showEdit("ログを作成", subTitle: "各項目を入力してください",closeButtonTitle: "Cancel")
    }
    
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    
    func postReqest(){
        SwiftSpinner.show("Posting...")
        
        tableTitleArray.append(newTitle)
        tableGoodArray.append(newGood)
        tableRevewArray.append(newRevew)
        
        let parameters:[String:AnyObject] = [
            "title": newTitle,
            "good": newGood,
            "revew": newRevew
        ]
        
        print(parameters)
        
        Alamofire.request(.POST, "https://yomi-ios-wadadon.c9users.io/new",parameters: parameters , encoding: .JSON)
            .responseString{ Error in
                print(Error)
                self.getArticles()
        }
        
        SwiftSpinner.hide()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
