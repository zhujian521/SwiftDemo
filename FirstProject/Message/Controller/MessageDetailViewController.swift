//
//  MessageDetailViewController.swift
//  FirstProject
//
//  Created by zhujian on 18/1/18.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class MessageDetailViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,CommentViewControllerDelegate{
    var tempModel:TbCircleModel!
    var tabelView:UITableView!
    var tempHeadView:SectionHeadView!
    var commentArr = [CommentModel]()
    var commentStringArr = [CommentStringModel]()
    var commentOrShare:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "详情"
        self.commentOrShare = true
        self.creatTableView()
        self.requestComment()
        self.requestShareData()
    }
    func creatTableView() -> Void {
        let pictureRowHeight:Int
        if self.tempModel.tbModel.sType == "1" {
            let clo:Int
            if self.tempModel.tbModel.cPhotoArr.count % 3 == 0 {
                clo = self.tempModel.tbModel.cPhotoArr.count / 3
            } else {
                clo = self.tempModel.tbModel.cPhotoArr.count / 3 + 1
                
            }
            pictureRowHeight = (clo) * (pictureMargin + pictureWidth + 8)
        } else {
            pictureRowHeight = Int(SCREEN_WIDTH - 20)
        }
      
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64 - 40), style: .plain)
        self.tabelView = tableView
        self.tabelView.delegate = self
        self.tabelView.dataSource = self
        let headView = MessageHeadView.init(frame: CGRect.init(x:0, y:0, width: kScreenWidth, height:70.0 + self.tempModel.tbModel.cContentHeight + CGFloat(pictureRowHeight) + 10.0))
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    
        headView.backgroundColor = UIColor.white
        headView.tempModel = self.tempModel
        headView.creatSubViews()

        self.tabelView.tableHeaderView = headView
        self.tabelView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        let header =  MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(self.headerRefresh))
        tableView.mj_header = header
        
        let headerSectionView = SectionHeadView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 70))
        headerSectionView.backgroundColor = UIColor.blue
        self.tempHeadView = headerSectionView
        headerSectionView.tempModel = self.tempModel
        headerSectionView.creatSubViews()
        headerSectionView.tempShareButton.addTarget(self, action: #selector(handlActionShare), for: .touchUpInside)
        headerSectionView.tempCommentButton.addTarget(self, action: #selector(handlActionComment), for: .touchUpInside)
        
        let toolBarView = ToolBarView.init(frame: CGRect.init(x: 0, y: SCREEN_HEIGHT - 104, width: SCREEN_WIDTH, height: 40))
        toolBarView.shareButton.backgroundColor = UIColor.lightGray
        toolBarView.commentButton.backgroundColor = UIColor.lightGray
        toolBarView.zanButton.backgroundColor = UIColor.lightGray
        toolBarView.backgroundColor = UIColor.lightGray
        self.view.addSubview(toolBarView)
        toolBarView.shareButton.addTarget(self, action: #selector(handleShareAction(_:)), for: .touchUpInside)
        toolBarView.zanButton.addTarget(self, action: #selector(handleZanAction(_:)), for: .touchUpInside)
        toolBarView.commentButton.addTarget(self, action: #selector(handleCommentAction(_:)), for: .touchUpInside)
    }
    func headerRefresh() -> Void {
        if self.commentOrShare! {
            self.requestComment()
        } else {
            self.requestShareData()
        }
    }
    func handlActionShare() -> Void {
        if !tempHeadView.tempRed1.isHidden {
            return
        }
        tempHeadView.tempRed1.isHidden = false
        tempHeadView.tempRed2.isHidden = true
        self.commentOrShare = true
        self.tabelView.reloadData()
    }
    func handlActionComment() -> Void {
        if !tempHeadView.tempRed2.isHidden {
            return
        }
        self.commentOrShare = false
        tempHeadView.tempRed1.isHidden = true
        tempHeadView.tempRed2.isHidden = false
        self.tabelView.reloadData()

    }
    func requestShareData() -> Void {
        var param = ["TokenID":String.readToken()]
        param.updateValue("1", forKey: "pageNum")
        param.updateValue(self.tempModel.tbModel.cId, forKey: "cId")
        self.showMBProgress()
        NetWorkWeather.sharedInstance.getRequest(urlString: self.getUserNMGBaseUrl(string: "searchCommentAPP"), params: param, success: { (json) -> Void in
            self.hideMBProgress()
            let jsonDic = JSON(json)
            print(jsonDic)
            self.tabelView.mj_header.endRefreshing()
            let status:String = jsonDic["status"].stringValue
            let message:String = jsonDic["message"].stringValue
            self.showMessage(message: message)
            if status == "1"{
                self.commentStringArr.removeAll()
                let comment = jsonDic["comment"].array
                for item in comment! {
                    let model = CommentStringModel.init(dic: item)
                    self.commentStringArr.append(model)
                    
                }
                self.tempHeadView.setCommentCount(count: self.commentStringArr.count)
                self.tabelView.reloadData()
                
                
            }

        }) { (error) in
            self.hideMBProgress()
            
        }

    }
    func requestComment() -> Void {
        var param = ["TokenID":String.readToken()]
        param.updateValue("1", forKey: "pageNum")
        param.updateValue(self.tempModel.tbModel.cId, forKey: "cId")
        NetWorkWeather.sharedInstance.getRequest(urlString: self.getUserNMGBaseUrl(string: "selectForwardAPP"), params: param, success: { (json) -> Void in
            let jsonDic = JSON(json)
            print(jsonDic)
            self.tabelView.mj_header.endRefreshing()
            let status:String = jsonDic["status"].stringValue
//            let message:String = jsonDic["message"].stringValue
//            self.showMessage(message: message)
            if status == "1"{
                let circles = jsonDic["circles"].array
                self.commentArr.removeAll()
                for item in circles! {
                    let model = CommentModel.init(dic: item)
                    self.commentArr.append(model)
                }
                self.tempHeadView.setShareCount(count: self.commentArr.count)
                self.tabelView.reloadData()
            }
            
        }) { (error) in
            self.hideMBProgress()
            
        }
        

        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.commentOrShare!{
            let model = self.commentArr[indexPath.row]
            return 50 + 10 + model.cContentHeight + 20

        } else {
            let model = self.commentStringArr[indexPath.row]
            return 50 + 10 + model.cContentHeight + 20

        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.commentOrShare!{
            return self.commentArr.count

        } else {
            return self.commentStringArr.count
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 70
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        return self.tempHeadView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.commentOrShare!{
            let cell:CommentTableViewCell = tabelView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommentTableViewCell
            let model = self.commentArr[indexPath.row]
            cell.configureValue(model: model)
            return cell

        } else {
            let cell:CommentTableViewCell = tabelView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommentTableViewCell
            let model = self.commentStringArr[indexPath.row]
            cell.configureContentString(model: model)
            return cell

        }

    }
    func handleShareAction(_ sender:UIButton) -> Void {
        print("---\(sender.tag)")
    }
    func handleCommentAction(_ sender:UIButton) -> Void {
        let commentVC = CommentViewController()
        commentVC.tempModel = self.tempModel
        commentVC.tempRow = 1 //这个不起作用
        commentVC.delegate = self
        self.navigationController?.pushViewController(commentVC, animated: true)

    }
    func handleZanAction(_ sender:UIButton) -> Void {
        var param = ["TokenID":String.readToken()]
        param.updateValue(self.tempModel.tbModel.cId, forKey: "cId")
        self.showMBProgress()
        NetWorkWeather.sharedInstance.postRequest(urlString: self.getUserNMGBaseUrl(string: "likeAPP"), params: param, success: { (json) -> Void in
            self.hideMBProgress()
            let jsonDic = JSON(json)
            print(jsonDic)
            let message:String = jsonDic["message"].stringValue
            let status:String = jsonDic["status"].stringValue
            if status == "1"{
                if message == "点赞成功"{
                    var countNumber = Int(self.tempModel.tbModel.cLikeNumber)
                    countNumber = countNumber! + 1
                    self.tempModel.tbModel.cLikeNumber = countNumber?.description
                    self.tempHeadView.setZanCount(count: self.tempModel.tbModel.cLikeNumber)
                } else {
                    var countNumber = Int(self.tempModel.tbModel.cLikeNumber)
                    countNumber = countNumber! - 1
                    self.tempModel.tbModel.cLikeNumber = countNumber?.description
                    self.tempHeadView.setZanCount(count: self.tempModel.tbModel.cLikeNumber)
                }
            }
            self.showMessage(message: message)
            
        }) { (errot) -> Void in
            self.hideMBProgress()
        }

    }
    func sendCommentAtRow(row: Int)  {
        self.requestShareData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
