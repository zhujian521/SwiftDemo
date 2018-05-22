//
//  HistoryVC.swift
//  FirstProject
//
//  Created by zhujian on 17/11/30.
//  Copyright © 2017年 zhujian. All rights reserved.
//

import UIKit
import MJRefresh
class HistoryVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var dataArr = [BicRelationModel]()
    var tableView:UITableView!
    var pageIndex:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "关联历史"
        self.tableView = UITableView.init(frame: self.view.bounds, style: UITableViewStyle.plain)
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = UIView.init()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.register(UINib.init(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
//        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        let header =  MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(self.headerRefresh))
        self.tableView!.mj_header = header
        self.tableView!.mj_header.beginRefreshing()
        let footer = MJRefreshAutoNormalFooter()
        footer.setRefreshingTarget(self, refreshingAction: #selector(self.footerRefresh))
        self.tableView!.mj_footer = footer
        self.view .addSubview(self.tableView)
        
    }
    func headerRefresh() -> Void {
        pageIndex = 1;
        self.refreshData(PullOrUp: true)

    }
    func footerRefresh() -> Void {
        pageIndex!+=1
        self.refreshData(PullOrUp: false)

    }
    func refreshData(PullOrUp:Bool) -> Void {
//        let readingString = "read"
        let dic:[String:String] =  String.readingData()
        let type = dic["type"]! as String
        let userId = dic["userId"]! as String
       
        var param:[String:String] = ["pageIndex":pageIndex.description]
        param.updateValue("5", forKey: "pageSize")
        param.updateValue(userId, forKey: "userId")
        param.updateValue(type, forKey: "type")
        param.updateValue("getBicRelation", forKey: "action")
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.bezelView.backgroundColor = UIColor.black
        hud.label.text = "数据加载中"
        XMSessionManager.shared1.request(Method:HTTPMethod.POST, URLString: getBaseURL(actionString: "getBicRelation"), parameters: param as [String : AnyObject]?) { (json:AnyObject?, isSuccess:Bool) in
            hud.hide(animated: true)
           
            let result = isSuccess
            if result {
                let dic:[String:Any] = json! as! [String : Any]
                let result_code:String = dic["result_code"] as! String
                let message:String = dic["message"] as! String
                self.showMessage(message: message)
                if PullOrUp{
                    self.dataArr.removeAll()
                    self.tableView!.mj_header.endRefreshing()
                    
                } else {
                    self.tableView!.mj_footer.endRefreshing()
                    
                }
                if let jsonDic = json as? NSDictionary {
                    let result_data = jsonDic["result_data"] as? NSDictionary
                    let bicRelation = result_data?["bicRelation"] as? NSArray
                    for value in bicRelation! {
                        let model = BicRelationModel.init(dict: value as! [String:String])
                        print("\(model.bicycleNumber!)")
                        self.dataArr.append(model);
                    }
                   
                    print(self.dataArr.count)
                    self.tableView.reloadData()
                }

                if result_code == "1" {
                    
                } else {

                }
                
            }
        }

            
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let model:BicRelationModel = self.dataArr[indexPath.row]
        cell.bicycleNumber.text = "锁码:" + model.code!
        cell.unlockNumber.text = "轮椅编码:" + model.bicycleNumber
        cell.creatTime.text = "关联时间:" + model.date
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
