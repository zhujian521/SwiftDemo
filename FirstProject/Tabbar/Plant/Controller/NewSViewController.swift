//
//  NewSViewController.swift
//  FirstProject
//
//  Created by zhujian on 18/2/8.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class NewSViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var dataArr = [CommonPostModel]()
    var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creatTableView()
//        self.requestShowFirst()

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
        let header =  MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(self.requestShowFirst))
        self.tableView!.mj_header = header
        self.tableView!.mj_header.beginRefreshing()
//        let footer = MJRefreshAutoNormalFooter()
//        footer.setRefreshingTarget(self, refreshingAction: #selector(self.footerRefresh))
//        self.tableView!.mj_footer = footer
        
    }

    func requestShowFirst() -> Void {
        var param = ["pageNum":"1"]
        param.updateValue("1232434", forKey: "TokenID")
        self.showMBProgress()
        var url =  String.readServerIP()
        url = url + String.readFirstTitel()
        NetWorkWeather.sharedInstance.getRequest(urlString: url, params: param, success: { (json) -> Void in
            self.hideMBProgress()
            self.tableView.mj_header.endRefreshing()
            let jsonDic = JSON(json)
            print(jsonDic)
            let status:String = jsonDic["status"].stringValue
            let message:String = jsonDic["message"].stringValue
            if status == "0" {
                self.showMessage(message: message)
            } else {
                let commonPosts = jsonDic["commonPosts"].arrayValue
                for item in commonPosts {
                    let model = CommonPostModel.init(dic: item)
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
        return 150
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
