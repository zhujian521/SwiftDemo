//
//  ChangeNameVC.swift
//  FirstProject
//
//  Created by zhujian on 18/1/8.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit

protocol ChangeNameVCDelegate {
    func changeUname(name:String) -> Void

}
class ChangeNameVC: BaseViewController,UITextFieldDelegate {
    var model:UserInfoModel?
    var uName:UITextField?
    var delegate:ChangeNameVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改昵称"
        let userNameTextFiled = UITextField.init(frame: CGRect.init(x: 10, y: 30, width: SCREEN_WIDTH - 20, height: 50))
        userNameTextFiled.backgroundColor = UIColor.white
        userNameTextFiled.placeholder = "请输入昵称"
        userNameTextFiled.clearButtonMode = UITextFieldViewMode.always
        userNameTextFiled.borderStyle = UITextBorderStyle.roundedRect
        userNameTextFiled.text = self.model?.uName
        userNameTextFiled.delegate = self
        self.uName = userNameTextFiled
        self.view.addSubview(userNameTextFiled)
        
        let rightBar = UIBarButtonItem.init(title: "保存", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleSaveUname))
        self.navigationItem.rightBarButtonItem = rightBar
        

    }
    func handleSaveUname() -> Void {
        if (self.uName?.text?.isEmpty)! {
            self.showMessage(message: "昵称不能为空")
            return
        }
        var param = ["uName":self.uName?.text]
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
                    self.delegate?.changeUname(name: (self.uName?.text!)!)
                    self.navigationController!.popViewController(animated: true)
                }

            }
            
            
        }
        
        
    }
//UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(textField.text!)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("结束编辑")
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("开始编辑")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
