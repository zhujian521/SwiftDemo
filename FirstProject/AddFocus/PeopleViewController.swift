//
//  PeopleViewController.swift
//  FirstProject
//
//  Created by zhujian on 18/1/22.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

protocol PeopleViewControllerDelegate {
    func refreshData() -> Void

}
class PeopleViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,CommentViewControllerDelegate{
    var model:AttentionPersonModel!
    var tempHeadView:PeopleHeadView!
    var dataArr = [TbCircleModel]()
    var tableView:UITableView!
    var delegate:PeopleViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.model.uName
        self.view.backgroundColor = UIColor.white
        let noMessage = UILabel.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height / 2 - 20, width: kScreenWidth, height: 25))
        noMessage.text = "暂无更多帖子"
        noMessage.textAlignment = .center
        self.view.addSubview(noMessage)
        let headView = PeopleHeadView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 70))
        headView.backgroundColor = UIColor.white
        self.tempHeadView = headView
        self.creatTableView()
        self.requstDataPersonInformation()
        
        let toolBarView = ToolBarView.init(frame: CGRect.init(x: 0, y: self.view.frame.height - 40 - 64, width: kScreenWidth, height: 40))
        toolBarView.backgroundColor = UIColor.lightGray
        var str = "取消关注"
        if self.model.amAttentionUserId.isEmpty {
            str = "关注"
            
        }
        toolBarView.setButtonTitle(str1: str, str2: "私密", str3: "推荐他(她)")
        toolBarView.zanButton.addTarget(self, action: #selector(handleAttention(_:)), for: .touchUpInside)
        toolBarView.commentButton.addTarget(self, action: #selector(handleChatWithPeople), for: .touchUpInside)
        toolBarView.shareButton.addTarget(self, action: #selector(handleAttentionAction), for: .touchUpInside)
        self.view.addSubview(toolBarView)

    }
    func creatTableView() -> Void {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64 - 50), style: UITableViewStyle.plain)
        self.view .addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(UINib.init(nibName: "TbCircleTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.register(UINib.init(nibName: "TbCircleVideoTableViewCell", bundle: nil), forCellReuseIdentifier: "Video")
        self.tableView = tableView
        self.tableView.tableHeaderView = self.tempHeadView
        let header =  MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(self.headerRefresh))
        self.tableView!.mj_header = header
//        self.tableView!.mj_header.beginRefreshing()
//        let footer = MJRefreshAutoNormalFooter()
//        footer.setRefreshingTarget(self, refreshingAction: #selector(self.footerRefresh))
//        self.tableView!.mj_footer = footer
        
    }
    func headerRefresh() -> Void {
        self.getAllUserCircleText()
    }

    func requstDataPersonInformation() -> Void {
        var param = ["key":33]
        if self.model.amAttentionUserId.isEmpty {
            param.updateValue(Int(self.model.uId)!, forKey: "userId")
        } else {
            param.updateValue(Int(self.model.amAttentionUserId)!, forKey: "userId")
        }
        self.showMBProgress()
        NetWorkWeather.sharedInstance.postRequest(urlString: self.getUserNMGBaseUrl(string: "selectUserInfos"), params: param, success: { (json) -> Void in
            self.hideMBProgress()
            let jsonDic = JSON(json)
            print(jsonDic)
            let status:String = jsonDic["status"].stringValue
            let message:String = jsonDic["message"].stringValue
            self.showMessage(message: message)
            if status == "1" {
                let userInfoAuthen:JSON = jsonDic["userInfoAuthen"]
                let userModel = UserInfoAuthenModel.init(dic: userInfoAuthen)
                userModel.fanNum = jsonDic["fanNum"].stringValue
                userModel.attentionNum = jsonDic["attentionNum"].stringValue
                self.tempHeadView.configureModel(model: userModel)
                self.getAllUserCircleText()
            }
            
        }) { (error) in
            self.hideMBProgress()
            
        }
    }
    func getAllUserCircleText() -> Void {
        var param = ["TokenID":String.readToken()]
        if self.model.amAttentionUserId.isEmpty {
            param.updateValue(self.model.uId, forKey: "userId")
        } else {
            param.updateValue(self.model.amAttentionUserId, forKey: "userId")
        }
        param.updateValue("1", forKey: "pageNum")
        self.showMBProgress()
        NetWorkWeather.sharedInstance.getRequest(urlString: self.getUserNMGBaseUrl(string: "selectCircleById"), params: param, success: { (json) -> Void in
            self.hideMBProgress()
            let jsonDic = JSON(json)
//            print(jsonDic)
            self.tableView.mj_header.endRefreshing()
            let status:String = jsonDic["status"].stringValue
            let tbCircles = jsonDic["tbCircle"].array
            if status == "1"{
                self.dataArr.removeAll()
                for item in tbCircles! {
                    print(item)
                    let model = TbCircleModel.init(dic: item)
                    let userID = String.readUid()
                    if userID != model.tbModel.cUserId{
                        self.dataArr.append(model)
                    }
                }
                if self.dataArr.count == 0{
                    self.tableView.backgroundColor = UIColor.clear
                    self.tableView.isScrollEnabled = false
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
        let model:TbCircleModel = self.dataArr[indexPath.row]
        if model.tbModel.sType == "2" {
            let cell:TbCircleVideoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Video", for: indexPath) as! TbCircleVideoTableViewCell
            cell.configureValue(model:model)
            cell.tempToolBar.shareButton.tag = indexPath.row
            cell.tempToolBar.commentButton.tag = indexPath.row
            cell.tempToolBar.zanButton.tag = indexPath.row
            cell.downButton.tag = indexPath.row
            cell.playButton.tag = indexPath.row
            cell.tempToolBar.shareButton.addTarget(self, action: #selector(handleShareAction(_:)), for: .touchUpInside)
            cell.tempToolBar.zanButton.addTarget(self, action: #selector(handleZanAction(_:)), for: .touchUpInside)
            cell.tempToolBar.commentButton.addTarget(self, action: #selector(handleCommentAction(_:)), for: .touchUpInside)
            cell.downButton.addTarget(self, action: #selector(handleActionDown(_:)), for: .touchUpInside)
            cell.playButton.addTarget(self, action: #selector(handlePlay(_:)), for: .touchUpInside)
            return cell
        } else {
            let cell:TbCircleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TbCircleTableViewCell
            cell.configureValue(model:model)
            cell.tempToolBar.shareButton.tag = indexPath.row
            cell.tempToolBar.commentButton.tag = indexPath.row
            cell.tempToolBar.zanButton.tag = indexPath.row
            cell.downButton.tag = indexPath.row
            cell.tempToolBar.shareButton.addTarget(self, action: #selector(handleShareAction(_:)), for: .touchUpInside)
            cell.tempToolBar.zanButton.addTarget(self, action: #selector(handleZanAction(_:)), for: .touchUpInside)
            cell.tempToolBar.commentButton.addTarget(self, action: #selector(handleCommentAction(_:)), for: .touchUpInside)
            cell.downButton.addTarget(self, action: #selector(handleActionDown(_:)), for: .touchUpInside)
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model:TbCircleModel = self.dataArr[indexPath.row]
        if model.tbModel.sType == "2" {
            return 70 + model.tbModel.cContentHeight + 10 + 10 +  UIScreen.main.bounds.width - 100 + 35
        }
        let clo:Int
        if model.tbModel.cPhotoArr.count % 3 == 0 {
            clo = model.tbModel.cPhotoArr.count / 3
        } else {
            clo = model.tbModel.cPhotoArr.count / 3 + 1
            
        }
        let pictureRowHeight = (clo) * (pictureMargin + pictureWidth + 8)
        return 70 + model.tbModel.cContentHeight + 10 + CGFloat(pictureRowHeight) + 40
    }
    func handleShareAction(_ sender:UIButton) -> Void {
        print("---\(sender.tag)")
        
        
    }
    func handleCommentAction(_ sender:UIButton) -> Void {
        let ZanModel:TbCircleModel = self.dataArr[sender.tag]
        let commentVC = CommentViewController()
        commentVC.tempModel = ZanModel
        commentVC.tempRow = sender.tag
        commentVC.delegate = self
        self.navigationController?.pushViewController(commentVC, animated: true)
        
    }
    func sendCommentAtRow(row: Int) {
        let ZanModel:TbCircleModel = self.dataArr[row]
        var countNumber = Int(ZanModel.tbModel.cCommentNumber)
        countNumber = countNumber! + 1
        ZanModel.tbModel.cCommentNumber = countNumber?.description
        let indexPath: IndexPath = IndexPath.init(row: row, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .none)
        
    }
    func handleZanAction(_ sender:UIButton) -> Void {
        let ZanModel:TbCircleModel = self.dataArr[sender.tag]
        var param = ["TokenID":String.readToken()]
        param.updateValue(ZanModel.tbModel.cId, forKey: "cId")
        self.showMBProgress()
        NetWorkWeather.sharedInstance.postRequest(urlString: self.getUserNMGBaseUrl(string: "likeAPP"), params: param, success: { (json) -> Void in
            self.hideMBProgress()
            let jsonDic = JSON(json)
            print(jsonDic)
            let message:String = jsonDic["message"].stringValue
            let status:String = jsonDic["status"].stringValue
            if status == "1"{
                if message == "点赞成功"{
                    var countNumber = Int(ZanModel.tbModel.cLikeNumber)
                    countNumber = countNumber! + 1
                    ZanModel.tbModel.cLikeNumber = countNumber?.description
                    let indexPath: IndexPath = IndexPath.init(row: sender.tag, section: 0)
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                    //                    self.tableView.reloadData()
                } else {
                    var countNumber = Int(ZanModel.tbModel.cLikeNumber)
                    countNumber = countNumber! - 1
                    ZanModel.tbModel.cLikeNumber = countNumber?.description
                    let indexPath: IndexPath = IndexPath.init(row: sender.tag, section: 0)
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                    //                    self.tableView.reloadData()
                    
                }
            }
            self.showMessage(message: message)
            
        }) { (errot) -> Void in
            self.hideMBProgress()
        }
        
        
    }
    func handleActionDown(_ sender:UIButton) -> Void {
        let ZanModel:TbCircleModel = self.dataArr[sender.tag]
        var isLike = "收藏"
        if ZanModel.isCollect == "1" {
            isLike = "取消收藏"
        } else {
            isLike = "收藏"
        }
        let uid = String.readUid()
        var titleArr = Array<String>()
        titleArr.append(isLike)
        if uid == ZanModel.tbModel.cUserId {
            titleArr.append("删除")
        } else {
            titleArr.append("举报")
            titleArr.append("屏蔽")
            
        }
        titleArr.append("取消")
        
        
        let menuView = ShowMenuView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), titleArr: titleArr)
        menuView.postValueBlock = { (str) in
            print(str)
            if str == "收藏" || str == "取消收藏" {
                self.postActionCollection(model: ZanModel)
            } else if str == "删除"{
                self.postActionDeleteCell(model: ZanModel, row: sender.tag)
            } else if str == "举报"{
                self.postReportToServe(model: ZanModel)
            } else if str == "屏蔽"{
                self.postShieldAPP(model: ZanModel, row: sender.tag)
            }
            
        }
        menuView.showView(navigaiton: self.tabBarController as! TabBarController)
    }
    func postActionCollection(model:TbCircleModel) -> Void {
        var urlString:String
        if model.isCollect == "1" {
            urlString = "collectAPP"
        } else {
            urlString = "collectAPP"
        }
        var param = ["TokenID":String.readToken()]
        param.updateValue(model.tbModel.cId, forKey: "cId")
        self.showMBProgress()
        NetWorkWeather.sharedInstance.postRequest(urlString: self.getUserNMGBaseUrl(string: urlString), params: param, success: { (json) -> Void in
            self.hideMBProgress()
            let jsonDic = JSON(json)
            print(jsonDic)
            let message:String = jsonDic["message"].stringValue
            let status:String = jsonDic["status"].stringValue
            self.showMessage(message: message)
            if status == "1"{
                if model.isCollect == "1"{
                    model.isCollect = "0"
                } else {
                    model.isCollect = "1"
                }
            }
            
        }) { (error) in
            self.hideMBProgress()
            
        }
        
    }
    func postActionDeleteCell(model:TbCircleModel,row:Int) -> Void {
        let urlString = "deleteAPP"
        var param = ["TokenID":String.readToken()]
        param.updateValue(model.tbModel.cId, forKey: "cId")
        self.showMBProgress()
        NetWorkWeather.sharedInstance.postRequest(urlString: self.getUserNMGBaseUrl(string: urlString), params: param, success: { (json) -> Void in
            self.hideMBProgress()
            let jsonDic = JSON(json)
            print(jsonDic)
            let message:String = jsonDic["message"].stringValue
            let status:String = jsonDic["status"].stringValue
            self.showMessage(message: message)
            if status == "1"{
                self.dataArr.remove(at: row)
                self.tableView.reloadData()
            }
            
        }) { (error) in
            self.hideMBProgress()
            
        }
        
    }
    func postReportToServe(model:TbCircleModel) -> Void {
        let urlString = "reportAPP"
        var param = ["TokenID":String.readToken()]
        param.updateValue(model.tbModel.cId, forKey: "cId")
        self.showMBProgress()
        NetWorkWeather.sharedInstance.postRequest(urlString: self.getUserNMGBaseUrl(string: urlString), params: param, success: { (json) -> Void in
            self.hideMBProgress()
            let jsonDic = JSON(json)
            print(jsonDic)
            let message:String = jsonDic["message"].stringValue
            //            let status:String = jsonDic["status"].stringValue
            self.showMessage(message: message)
            
        }) { (error) in
            self.hideMBProgress()
            
        }
        
    }
    func postShieldAPP(model:TbCircleModel,row:Int) -> Void {
        let urlString = "shieldAPP"
        var param = ["TokenID":String.readToken()]
        param.updateValue(model.tbModel.cId, forKey: "cId")
        self.showMBProgress()
        NetWorkWeather.sharedInstance.postRequest(urlString: self.getUserNMGBaseUrl(string: urlString), params: param, success: { (json) -> Void in
            self.hideMBProgress()
            let jsonDic = JSON(json)
            print(jsonDic)
            let message:String = jsonDic["message"].stringValue
            let status:String = jsonDic["status"].stringValue
            self.showMessage(message: message)
            if status == "1"{
                self.dataArr.remove(at: row)
                self.tableView.reloadData()
            }
            
        }) { (error) in
            self.hideMBProgress()
            
        }
        
    }
    func handlePlay(_ sender:UIButton) -> Void {
        let ZanModel:TbCircleModel = self.dataArr[sender.tag]
        let urlString = self.getHeadimgurl(path: ZanModel.tbModel.cPhoto)
        print("===========\(urlString)")
        
    }
    func handleAttention(_ sender:UIButton) -> Void {
        var param = ["TokenID":String.readToken()]
        if self.model.amAttentionUserId.isEmpty {
            param.updateValue(self.model.uId, forKey: "reUserId")
        } else {
            param.updateValue(self.model.amAttentionUserId, forKey: "reUserId")
        }
        self.showMBProgress()
        NetWorkWeather.sharedInstance.postRequest(urlString: self.getUserNMGBaseUrl(string: "recommend"), params: param, success: { (json) in
            self.hideMBProgress()
            let jsonDic = JSON(json)
            print(jsonDic)
            let message:String = jsonDic["message"].stringValue
            let status:String = jsonDic["status"].stringValue
            self.showMessage(message: message)
            //            if status == "1"{
            
            
        }) { (error) in
            self.hideMBProgress()
            
            
        }

    }
    func handleChatWithPeople() -> Void {
        
    }
    func handleAttentionAction() -> Void {
    
        var param = ["TokenID":String.readToken()]
        if self.model.amAttentionUserId.isEmpty {
            param.updateValue(self.model.uId, forKey: "attention_user_id")
        } else {
            param.updateValue(self.model.amAttentionUserId, forKey: "attention_user_id")
        }

        self.showMBProgress()
        NetWorkWeather.sharedInstance.postRequest(urlString: "http://120.77.211.200/attentionAPP/selectTbAttentionMeById", params: param, success: { (json) -> Void in
            self.hideMBProgress()
            let jsonDic = JSON(json)
            let status:String = jsonDic["status"].stringValue
            let message:String = jsonDic["message"].stringValue
            self.showMessage(message: message)
            if status == "1" {
                self.delegate?.refreshData()
                self.navigationController!.popViewController(animated: true)
            }
            
        }) { (error) in
            self.hideMBProgress()
            
        }

        
    }
    




    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
