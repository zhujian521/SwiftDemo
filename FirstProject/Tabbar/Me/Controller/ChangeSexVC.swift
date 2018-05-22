//
//  ChangeSexVC.swift
//  FirstProject
//
//  Created by zhujian on 18/1/8.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit

protocol ChangeSexVCDelegate {
    func changeSex(newSex:String) -> Void
}
class ChangeSexVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var model:UserInfoModel?
    var tempTableView:UITableView?
    var tempRow:Int?
    var delegate:ChangeSexVCDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creatTableView()

    }
    func creatTableView() -> Void {
        let tableView = UITableView.init(frame: self.view.bounds, style: UITableViewStyle.plain)
        self.view .addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init()
        tableView.backgroundColor = UIColor.clear

        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(UINib.init(nibName: "SexTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tempTableView = tableView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SexTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SexTableViewCell
        cell.selectImage.isHidden = true
        if indexPath.row == 0 {
            cell.sexLabel?.text = "男"
            if self.model?.uSex == "男"{
                cell.selectImage.isHidden = false
                self.tempRow = indexPath.row
            } else {
                cell.selectImage.isHidden = true
 
            }

        } else {
            if self.model?.uSex == "女"{
                cell.selectImage.isHidden = false
                self.tempRow = indexPath.row

            } else {
                cell.selectImage.isHidden = true
                
            }
            cell.sexLabel?.text = "女"

        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:SexTableViewCell = tableView.cellForRow(at: indexPath) as! SexTableViewCell
        if tempRow == nil {

            self.saveSexToServe(sex: cell.sexLabel.text!)
        } else {
            if indexPath.row != tempRow {
            self.saveSexToServe(sex: cell.sexLabel.text!)

            }
        }
    }
    func saveSexToServe(sex:String) -> Void {
        var param = ["uSex":sex]
        param.updateValue(String.readToken(), forKey: "TokenID")
        self.showMBProgress()
        XMSessionManager.shared.request(Method: .POST, URLString: self.getNMGBaseUrl(actionString: "updateMe"), parameters: param as [String : AnyObject]?) { (json:AnyObject?, isSuccess:Bool?) in
            self.hideMBProgress()
            if isSuccess!{
                let dic:[String:AnyObject] = json! as! [String : AnyObject]
                print(dic)
                let status:String = dic["status"] as! String
                let message:String = dic["message"] as! String
                self.showMessage(message: message)
                if Int(status) == 1{
                    self.delegate?.changeSex(newSex: sex)
                    self.navigationController!.popViewController(animated: true)
                }
                
            }
        
            
        }

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
