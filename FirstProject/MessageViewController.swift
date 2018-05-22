//
//  MessageViewController.swift
//  FirstProject
//
//  Created by zhujian on 17/12/29.
//  Copyright © 2017年 zhujian. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class MessageViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,CommentViewControllerDelegate {
    var dataArr = [TbCircleModel]()
    var tableView:UITableView!
    var pageIndex:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "农业圈"
        self.checkToken()
        self.creatTableView()
        self.addNavigation()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func addNavigation() -> Void {
        self.navigationItem.leftBarButtonItem = CustomBarButton.createBarbuttonItem(name: "navigationbar_friendsearch", target: self, action: #selector(leftAction))
        self.navigationItem.rightBarButtonItem = CustomBarButton.createBarbuttonItem(name: "ic_mail-15", target: self, action: #selector(rightAction))
        
    }
    
    func rightAction() -> Void {
        
        let menuView = ShowMenuView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), titleArr: ["图片","视频","取消"])
        menuView.postValueBlock = { (str) in
            if str == "图片" {
                let vc = SendPictureViewController()
                let navigation = BaseNavigationVC.init(rootViewController: vc)
               self.present(navigation, animated: true, completion: nil)
            }else if str == "视频"{
                let vc = SendVideoViewController()
                vc.saveClose = { (_ image:UIImage , _ url:URL) in
                    print("闭包传智\(url)")
                    let uploadVC = UpLoadVideoVC()
                    uploadVC.tempImage = image
                    uploadVC.URL = url
                    self.navigationController?.pushViewController(uploadVC, animated: true)
                    
                }
                self.present(vc, animated: true, completion: nil)
            }
        }
        menuView.showView(navigaiton: self.tabBarController as! TabBarController)

        
    }
    func creatTableView() -> Void {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 49), style: UITableViewStyle.plain)
        self.view .addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(UINib.init(nibName: "TbCircleTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.register(UINib.init(nibName: "TbCircleVideoTableViewCell", bundle: nil), forCellReuseIdentifier: "Video")
        self.tableView = tableView
        let header =  MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(self.headerRefresh))
        self.tableView!.mj_header = header
        self.tableView!.mj_header.beginRefreshing()
        let footer = MJRefreshAutoNormalFooter()
        footer.setRefreshingTarget(self, refreshingAction: #selector(self.footerRefresh))
        self.tableView!.mj_footer = footer

    }
    func leftAction() -> Void {
        let vc = AllPersonListVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func headerRefresh() -> Void {
        pageIndex = 1;
        self.refreshData(PullOrUp: true)
        
    }
    func footerRefresh() -> Void {
        pageIndex!+=1
        self.refreshData(PullOrUp: false)
        
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model:TbCircleModel = self.dataArr[indexPath.row]

            let VC = MessageDetailViewController()
            VC.tempModel = model
            self.navigationController!.pushViewController(VC, animated: true)
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
    func refreshData(PullOrUp:Bool) -> Void {
        var param = ["TokenID":String.readToken()]
        param.updateValue(pageIndex.description, forKey: "pageNum")
        self.showMBProgress()
        NetWorkWeather.sharedInstance.getRequest(urlString: self.getUserNMGBaseUrl(string: "selectByAttention"), params: param, success: {(json) -> Void in
            self.hideMBProgress()
            let jsonDic = JSON(json)
            let status:String = jsonDic["status"].stringValue
            let message:String = jsonDic["message"].stringValue
            let tbCircles = jsonDic["tbCircles"].array
            if PullOrUp{
                self.dataArr.removeAll()
                self.showMessage(message: message)
                self.tableView!.mj_header.endRefreshing()
                
            } else {
                self.tableView!.mj_footer.endRefreshing()
                if tbCircles?.count == 0{
                    self.showMessage(message: "暂无更多数据")
                    return
                }
                
            }

//            print(jsonDic)
            if status == "1"{
                for item in tbCircles! {
//                    print(item)
                    let model = TbCircleModel.init(dic: item)
                    self.dataArr.append(model)
                    
                }
                self.tableView.reloadData()
                
            }
            
        }, failture: {(error) -> Void in
            self.hideMBProgress()
            print(error)
            if PullOrUp{
                self.tableView!.mj_header.endRefreshing()
                
            } else {
                self.tableView!.mj_footer.endRefreshing()
            }

        })

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
        var url = "http://120.77.211.200/"
        url = url + "image/getImg?path="
        url = url + ZanModel.tbModel.cPhoto
        print("===========\(url)")

    }
    
    
    


}
