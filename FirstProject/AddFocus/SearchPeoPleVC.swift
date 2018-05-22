//
//  SearchPeoPleVC.swift
//  FirstProject
//
//  Created by zhujian on 18/2/3.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class SearchPeoPleVC: BaseViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {
    var searchBar:UISearchBar!
    var dataArr = [AttentionPersonModel]()
    var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar = UISearchBar.init(frame: CGRect.init(x: 80, y: 24, width: 120, height: 40))
        self.searchBar.placeholder = "请输入好友昵称"
        self.searchBar.barStyle = .black
        self.searchBar.tintColor = UIColor.blue
        self.searchBar.showsCancelButton = true
        self.searchBar.delegate = self
        self.navigationItem.titleView = self.searchBar
        self.creatTableView()

    }
    func creatTableView() -> Void {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT  - 64), style: UITableViewStyle.plain)
        self.view .addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(UINib.init(nibName: "FocusedTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
//tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.tableView = tableView
//        let header =  MJRefreshNormalHeader()
//        header.setRefreshingTarget(self, refreshingAction: #selector(self.headerRefresh))
//        self.tableView!.mj_header = header
//        self.tableView!.mj_header.beginRefreshing()
//        let footer = MJRefreshAutoNormalFooter()
//        footer.setRefreshingTarget(self, refreshingAction: #selector(self.footerRefresh))
//        self.tableView!.mj_footer = footer
        
    }

    override func touchesBegan(_ touches:Set<UITouch>, with event:UIEvent?) {
       self.searchBar.resignFirstResponder()
    }

    //UISearchBarDelegate
    func searchBar(_ searchBar:UISearchBar, textDidChange searchText:String) {
                print(searchText)
    }
    func searchBarCancelButtonClicked(_ searchBar:UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar:UISearchBar) {
        self.searchBar.resignFirstResponder()
        print(self.searchBar.text!)
        self.searchData(str: self.searchBar.text!)

    }
    func searchData(str:String) -> Void {
        var param = ["TokenID":String.readToken()]
        param.updateValue(str, forKey: "nickName")
        param.updateValue("1", forKey: "pageNum")
        self.showMBProgress()
        NetWorkWeather.sharedInstance.getRequest(urlString: self.getUserNMGBaseUrl(string: "searchFriendByNickName"), params: param, success: { (json) -> Void in
            self.hideMBProgress()
            let jsonDic = JSON(json)
            print(jsonDic)
            let status:String = jsonDic["status"].stringValue
            let message:String = jsonDic["message"].stringValue
            if status == "1"{
                let List = jsonDic["list"].array
                self.dataArr.removeAll()
                for item in List! {
                    let user = item["user"]
                    let model = AttentionPersonModel.init(dic: user)
                    model.attentioned = item["attentioned"].stringValue
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
        if model.attentioned == "0" {
            cell.followedImage.isHidden = true
            cell.followedButton.isHidden = false
        } else {
            cell.followedImage.isHidden = false
            cell.followedButton.isHidden = true
        }
//        cell.ImageButton.addTarget(self, action: #selector(handleActionPerson(_:)), for: .touchUpInside)
        return cell
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
