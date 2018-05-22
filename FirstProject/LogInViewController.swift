//
//  LogInViewController.swift
//  FirstProject
//
//  Created by zhujian on 17/11/22.
//  Copyright © 2017年 zhujian. All rights reserved.
//

import UIKit
import AFNetworking
class LogInViewController: BaseViewController {

    var tempUserName:UITextField?
    var tempPassWord:UITextField?
    var tempButton:UIButton?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "登录"
        creatTextFeildView()
    }
    func creatTextFeildView() -> Void {
        let userName = UITextField.init(frame: CGRect.init(x: 15, y: 50, width: SCREEN_WIDTH - 30, height: 44))
        userName.backgroundColor = UIColor.white
        userName.placeholder = "请输入账号"
        userName.borderStyle = UITextBorderStyle.roundedRect
        userName.clearButtonMode = UITextFieldViewMode.always
        tempUserName = userName
        userName .addTarget(self, action: #selector(handleValueChangeAction(_:)), for: UIControlEvents.editingChanged)
        self.view.addSubview(userName)
        let leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 44))
        let leftImageView = UIImageView.init(frame: CGRect.init(x: 10, y: 7, width: 30, height: 30))
        leftImageView.image = UIImage.init(named: "ic_phone-16")
        leftView.addSubview(leftImageView)

        userName.leftView = leftView
        userName.leftViewMode = UITextFieldViewMode.always

        
        let passWord = UITextField.init(frame: CGRect.init(x: 15, y: userName.frame.maxY + 30, width:SCREEN_WIDTH - 30, height: 44))
        passWord.placeholder = "输入密码"
        passWord.backgroundColor = UIColor.white
        passWord.borderStyle = UITextBorderStyle.roundedRect
        passWord.keyboardType = UIKeyboardType.numberPad
        passWord.clearButtonMode = UITextFieldViewMode.always
        self.view.addSubview(passWord)
        passWord .addTarget(self, action: #selector(handleValueChangeAction(_:)), for: UIControlEvents.editingChanged)
        tempPassWord = passWord
        
        let rightView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 44))
        let rightImageView = UIImageView.init(frame: CGRect.init(x: 10, y: 7, width: 30, height: 30))
        rightImageView.image = UIImage.init(named: "ic_password-15")
        rightView.addSubview(rightImageView)
        passWord.leftView = rightView
        passWord.leftViewMode = UITextFieldViewMode.always

        
        let loginButton = UIButton.init(frame: CGRect.init(x: 15, y: passWord.frame.maxY + 30, width:SCREEN_WIDTH - 30, height: 44))
        loginButton.setUpNormalAndSelect()
        loginButton.isEnabled = false
        tempButton = loginButton
        loginButton .addTarget(self, action: #selector(handleActionLogin(_:)), for: UIControlEvents.touchUpInside)
        loginButton.setTitle("登录", for: UIControlState.normal)
        self.view.addSubview(loginButton)
        
        
    }
    func handleActionLogin(_ sender:UIButton) -> Void {
        self.view.endEditing(true)
        var param = ["account":tempUserName!.text]
        let passWord =  String.md5(forLower32Bate:tempPassWord?.text!)
        param.updateValue(passWord, forKey: "password")
        param.updateValue("login", forKey: "action")
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.bezelView.backgroundColor = UIColor.black
        hud.label.text = "数据加载中"
        XMSessionManager.shared1.request(Method: HTTPMethod.POST, URLString: getBaseURL(actionString: "login"), parameters: param as [String : AnyObject]?) { (json:AnyObject?, isSuccess:Bool?) in
            hud.hide(animated: true)
            let result = isSuccess
            if result! {
                let dic:[String:AnyObject] = json! as! [String : AnyObject]
                let result_code:String = dic["result_code"] as! String
                let message:String = dic["message"] as! String
                print(dic)
                if result_code == "1" {
                    self.textShow(message: message)
                } else {
                    let result_data:[String:AnyObject] = dic["result_data"] as! [String:AnyObject]
//                    let type:String = String(describing: result_data["type"])
                    String.saveUserInformation(param: result_data)
                    self.changeTabbarAsWindow()
                }
 
            }
        }
    }
    
    func handleValueChangeAction(_ sender:UITextField) -> Void {
        if tempPassWord?.text?.characters.count != 0 &&  tempUserName?.text?.characters.count != 0{
            tempButton?.isEnabled = true
        } else {
            tempButton?.isEnabled = false

        }
    }
    
    func textShow(message:String){
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.label.text = message
        hud.hide(animated: true, afterDelay: 0.8)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
