//
//  FocusedViewController.swift
//  FirstProject
//
//  Created by zhujian on 18/1/20.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class FocusedViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,PeopleViewControllerDelegate {
    var dataArr = [AttentionPersonModel]()
    var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creatTableView()
    }
    func creatTableView() -> Void {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 49 - 64), style: UITableViewStyle.plain)
        self.view .addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(UINib.init(nibName: "FocusedTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
//        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.tableView = tableView
        let header =  MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(self.headerRefresh))
        self.tableView!.mj_header = header
        self.tableView!.mj_header.beginRefreshing()
//        let footer = MJRefreshAutoNormalFooter()
//        footer.setRefreshingTarget(self, refreshingAction: #selector(self.footerRefresh))
//        self.tableView!.mj_footer = footer
        
    }
    func headerRefresh() -> Void {
        self.requestSelectAttentionuserAPP(refreshOrLoadMore: true)

    }
    func requestSelectAttentionuserAPP(refreshOrLoadMore:Bool) -> Void {
        var param = ["TokenID":String.readToken()]
        param.updateValue("1", forKey: "pageNum")
        self.showMBProgress()
        NetWorkWeather.sharedInstance.getRequest(urlString: self.getUserNMGBaseUrl(string: "selectAttentionuserAPP"), params: param, success: { (json) -> Void in
            self.hideMBProgress()
            if refreshOrLoadMore {
                self.tableView.mj_header.endRefreshing()
            }
            let jsonDic = JSON(json)
            let status:String = jsonDic["status"].stringValue
            let message:String = jsonDic["message"].stringValue
            if status == "1"{
                let List = jsonDic["List"].array
                self.dataArr.removeAll()
                for item in List! {
//                    print(item)
                    let model = AttentionPersonModel.init(dic: item)
                    self.dataArr.append(model)

                }
                self.tableView!.reloadData()
                
                
            } else {
                self.showMessage(message: message)
            }

            
        }) { (error) in
            self.hideMBProgress()
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FocusedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FocusedTableViewCell
        let model:AttentionPersonModel = self.dataArr[indexPath.row]
        cell.configureUserInformation(model: model)
        cell.ImageButton.tag = indexPath.row
        cell.ImageButton.addTarget(self, action: #selector(handleActionPerson(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model:AttentionPersonModel = self.dataArr[indexPath.row]
        let alertController = UIAlertController.init(title: "提示", message: "是否要取消关注此好友？", preferredStyle: .alert)
        let action1 = UIAlertAction.init(title: "取消", style: .cancel) { (UIAlertAction) -> Void in
            
        }
        let action2 = UIAlertAction.init(title: "确定", style: .default) { (UIAlertAction) -> Void in
            self.addFollowWithUserID(model: model, row: indexPath.row)
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: { })

    }
    func addFollowWithUserID(model:AttentionPersonModel,row:Int) -> Void {
        var param = ["TokenID":String.readToken()]
        param.updateValue(model.amAttentionUserId, forKey: "attention_user_id")
        self.showMBProgress()
        NetWorkWeather.sharedInstance.postRequest(urlString: "http://120.77.211.200/attentionAPP/selectTbAttentionMeById", params: param, success: { (json) -> Void in
            self.hideMBProgress()
            let jsonDic = JSON(json)
            let status:String = jsonDic["status"].stringValue
            let message:String = jsonDic["message"].stringValue
            self.showMessage(message: message)
            if status == "1" {
                self.dataArr.remove(at: row)
                self.tableView.reloadData()
            }
            
        }) { (error) in
            self.hideMBProgress()
            
        }
        
    }
    func handleActionPerson(_ sender:UIButton) -> Void {
        let model:AttentionPersonModel = self.dataArr[sender.tag]
        let vc = PeopleViewController()
        vc.model = model
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)

    }
    func refreshData() -> Void {
        self.headerRefresh()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
