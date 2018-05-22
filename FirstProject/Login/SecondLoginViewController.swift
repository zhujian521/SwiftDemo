//
//  SecondLoginViewController.swift
//  FirstProject
//
//  Created by zhujian on 18/1/4.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit
import SwiftyJSON

class SecondLoginViewController: BaseViewController {
    var tempCodeButton:UIButton?
    var tempPhoneText:UITextField?
    var tempCodeText:UITextField?
    var tempLoginButto:UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.title = "登录"
        self.creatTextFeildView()
    }
    func creatTextFeildView() -> Void {
        let phoneTextFeild = UITextField.init(frame: CGRect.init(x: 15, y: 60, width: SCREEN_WIDTH - 30, height: 50))
        self.view.addSubview(phoneTextFeild)
        phoneTextFeild.placeholder = "请输入手机号码"
        phoneTextFeild.keyboardType = .numberPad
        phoneTextFeild.backgroundColor = UIColor.white
        phoneTextFeild.borderStyle = UITextBorderStyle.roundedRect
        phoneTextFeild.clearButtonMode = UITextFieldViewMode.always
        phoneTextFeild.addTarget(self, action: #selector(phoneTextChange(_:)), for: UIControlEvents.editingChanged)
        tempPhoneText = phoneTextFeild
        let leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 44))
        let leftImageView = UIImageView.init(frame: CGRect.init(x: 10, y: 7, width: 30, height: 30))
        leftImageView.image = UIImage.init(named: "ic_phone-16")
        leftView.addSubview(leftImageView)
        
        phoneTextFeild.leftView = leftView
        phoneTextFeild.leftViewMode = UITextFieldViewMode.always
        
        let rightView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 90, height: 44))
        rightView.backgroundColor = UIColor.clear
        phoneTextFeild.rightView = rightView
        phoneTextFeild.rightViewMode = UITextFieldViewMode.always
        
        let codeButton = UIButton.init(frame: CGRect.init(x: 5, y: 5, width: 80, height: 35))
        rightView.addSubview(codeButton)
        codeButton.setUpNormalAndSelect()
        codeButton.setTitle("获取验证码", for: UIControlState.normal)
        codeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        codeButton.isEnabled = false
        tempCodeButton = codeButton
        codeButton.addTarget(self, action: #selector(handelSendCode), for: UIControlEvents.touchUpInside)
        
    
        let codeTextFeild = UITextField.init(frame: CGRect.init(x: 15, y: 140, width: SCREEN_WIDTH - 30, height: 50))
        self.view.addSubview(codeTextFeild)
        codeTextFeild.placeholder = "输入验证码"
        codeTextFeild.backgroundColor = UIColor.white;
        codeTextFeild.borderStyle = UITextBorderStyle.roundedRect
        codeTextFeild.clearButtonMode = UITextFieldViewMode.always
        codeTextFeild.keyboardType = .numberPad
        tempCodeText = codeTextFeild
        codeTextFeild.addTarget(self, action: #selector(phoneTextChange(_:)), for: UIControlEvents.editingChanged)
        let codeLeftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 44))
        let rightImageView = UIImageView.init(frame: CGRect.init(x: 10, y: 7, width: 30, height: 30))
        rightImageView.image = UIImage.init(named: "ic_password-15")
        codeLeftView.addSubview(rightImageView)
        codeTextFeild.leftView = codeLeftView
        codeTextFeild.leftViewMode = UITextFieldViewMode.always

        let loginButton = UIButton.init(frame: CGRect.init(x: 15, y:220, width: SCREEN_WIDTH - 30, height: 44))
        self.view.addSubview(loginButton)
        loginButton.setUpNormalAndSelect()
        loginButton.isEnabled = false
        loginButton.setTitle("登录", for: UIControlState.normal)
        tempLoginButto = loginButton
        loginButton.addTarget(self, action: #selector(handleActionLogin(_:)), for: UIControlEvents.touchUpInside)
        
    }
    func phoneTextChange(_ sender:UITextField) -> Void {
        if tempPhoneText?.text!.characters.count == 11 {
            tempCodeButton?.isEnabled = true
        } else {
            tempCodeButton?.isEnabled = false
        }
        if (tempPhoneText?.text!.characters.count)! == 11 && (tempCodeText?.text?.characters.count)! > 2{
            tempLoginButto?.isEnabled = true
        } else {
            tempLoginButto?.isEnabled = false
        }
        
    }
    func handelSendCode() -> Void {
//        if !self.validatePhoneNumber(email:(tempPhoneText?.text)!) {
//            self.showMessage(message: "请输入正确的电话号码")
//            return;
//            
//        }
        self.view.endEditing(true)
        tempCodeButton?.countDown(count: 59)
        let param = ["phone":tempPhoneText?.text]
        self.showMBProgress()
        XMSessionManager.shared1.request(Method: .POST, URLString: self.getNMGBaseUrl(actionString: "obtainPhoneVerificationCode"), parameters: param as [String : AnyObject]?) { (json:AnyObject?, isSuccess:Bool?) in
            self.hideMBProgress()
            if isSuccess! {
                let dic:[String:Any] = json! as! [String : Any]
                let message:String = dic["message"] as! String
                self.showMessage(message: message);
                print("\(dic)=")


            } else {
                self.showMessage(message: "网络故障请检查")
            }

        }
        

    }
    func handleActionLogin(_ sender:UIButton) -> Void {
        if tempPhoneText?.text?.characters.count != 11 {
            self.showMessage(message: "手机号码错误")
            return;
        }
        if tempCodeText?.text?.characters.count == 0 {
            self.showMessage(message: "验证码不能为空")
            return;

        }
        self.view.endEditing(true)
        var param = ["phone":(tempPhoneText?.text)!]
        param.updateValue((tempCodeText?.text)!, forKey: "verificationCode")
        self.showMBProgress()
        XMSessionManager.shared1.request(Method: .POST, URLString: self.getNMGBaseUrl(actionString: "/phoneLogin"), parameters: param as [String:AnyObject]?) { (json:AnyObject?, isSuccess:Bool?) in
            self.hideMBProgress()
            if isSuccess! {
                let dic:[String:AnyObject] = json! as! [String : AnyObject]
                let status:String = dic["status"] as! String
                let message:String = dic["message"] as! String
                self.showMessage(message: message);
                if Int(status) == 1{
                    let TokenID:String = dic["TokenID"] as! String
                    let jsonDic = JSON(json as Any)
                    let userInfo = JSON(jsonDic["userInfo"])
                    let uId = userInfo["uId"].stringValue
                    String.saveUid(uid: uId)
                    String.saveTokenID(token: TokenID)
                    self.sendLoginSuccessNotification()
                    self.navigationController!.popViewController(animated: true)
                }

                print("\(dic)")
                
                
            } else {
                self.showMessage(message: "网络故障请检查")
            }


            
        }
        
        
    }
    func sendLoginSuccessNotification() -> Void {
        let notificationName = Notification.Name(rawValue: "loginSuccess")
        NotificationCenter.default.post(name: notificationName, object: self,
                                        userInfo: ["value1":"hangge.com", "value2" : 12345])
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
