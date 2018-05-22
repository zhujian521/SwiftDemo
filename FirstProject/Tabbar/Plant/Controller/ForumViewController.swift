//
//  ForumViewController.swift
//  FirstProject
//
//  Created by zhujian on 18/2/26.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class ForumViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var fidString:String?
    var dataArr = [CommonPostModel]()
    var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.creatTableView()
        self.requestShowFirst()
    }
    func creatTableView() -> Void {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 49 - 64 - 40), style: UITableViewStyle.plain)
        self.view .addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(UINib.init(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView = tableView
        
    }

    func requestShowFirst() -> Void {
        var param = ["pageNum":"1"]
        param.updateValue("1232434", forKey: "TokenID")
        param.updateValue(self.fidString!, forKey: "forumId")
        self.showMBProgress()
        var url =  String.readServerIP()
        url = url + String.readMeAppSelectNews()
        NetWorkWeather.sharedInstance.getRequest(urlString: url, params: param, success: { (json) -> Void in
            self.hideMBProgress()
            let jsonDic = JSON(json)
            print(jsonDic)
            let status:String = jsonDic["status"].stringValue
            let message:String = jsonDic["message"].stringValue
            if status == "0" {
                self.showMessage(message: message)
            } else {
                let newestReplyPosts = jsonDic["newestReplyPosts"].arrayValue
                for item in newestReplyPosts {
                    let tbPost = item["tbPost"]
                    let model = CommonPostModel.init(dic: tbPost)
                    self.dataArr.append(model)
                }
                self.tableView.reloadData()
                
            }
            
            
        }) { (error) in
            self.hideMBProgress()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewsTableViewCell
        let model:CommonPostModel = self.dataArr[indexPath.row]
        cell.configureModel(model: model)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model:CommonPostModel = self.dataArr[indexPath.row]
        if model.pPhoto.isEmpty {
            return 100
        }
        return 150
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
