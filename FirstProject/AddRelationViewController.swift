//
//  AddRelationViewController.swift
//  FirstProject
//
//  Created by zhujian on 18/2/24.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit

class AddRelationViewController: BaseViewController,ScanCodeViewControlProtol {
    var tempUnlockField:UITextField?
    var tempBycleNumberField:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creatTextFeildView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func creatTextFeildView() -> Void {
        let userName = UITextField.init(frame: CGRect.init(x: 15, y: 50, width: SCREEN_WIDTH - 30, height: 44))
        userName.backgroundColor = UIColor.white
        userName.placeholder = "请输入锁编号"
        userName.borderStyle = UITextBorderStyle.roundedRect
        userName.clearButtonMode = UITextFieldViewMode.always
        userName .addTarget(self, action: #selector(handleValueChangeAction(_:)), for: UIControlEvents.editingChanged)
        self.tempUnlockField = userName
        userName.keyboardType = UIKeyboardType.numberPad

        self.view.addSubview(userName)
        let leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 44))
        let leftImageView = UIButton.init(frame: CGRect.init(x: 10, y: 7, width: 30, height: 30))
        leftImageView.addTarget(self, action: #selector(handleUnlock(_:)), for: .touchUpInside)
        leftImageView.setImage(UIImage.init(named: "navigationbar_pop"), for: .normal)
        leftView.addSubview(leftImageView)
        userName.rightView = leftView
        userName.rightViewMode = UITextFieldViewMode.always
        
        
        let passWord = UITextField.init(frame: CGRect.init(x: 15, y: 120, width:SCREEN_WIDTH - 30, height: 44))
        passWord.placeholder = "请输入轮椅编号"
        self.tempBycleNumberField = passWord
        passWord.backgroundColor = UIColor.white
        passWord.borderStyle = UITextBorderStyle.roundedRect
        passWord.keyboardType = UIKeyboardType.numberPad
        passWord.clearButtonMode = UITextFieldViewMode.always
        self.view.addSubview(passWord)
        passWord .addTarget(self, action: #selector(handleValueChangeAction(_:)), for: UIControlEvents.editingChanged)
        let rightView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 44))
        let rightImageView = UIButton.init(frame: CGRect.init(x: 10, y: 7, width: 30, height: 30))
        rightImageView.setImage(UIImage.init(named: "navigationbar_pop_highlighted"), for: .normal)
        rightImageView.addTarget(self, action: #selector(handleBycicle(_:)), for: .touchUpInside)

        rightView.addSubview(rightImageView)
        passWord.rightView = rightView
        passWord.rightViewMode = UITextFieldViewMode.always
        
        
        let loginButton = UIButton.init(frame: CGRect.init(x: 15, y: 200, width:SCREEN_WIDTH - 30, height: 44))
        loginButton.setUpNormalAndSelect()
        loginButton.isEnabled = true
        loginButton .addTarget(self, action: #selector(handleActionLogin(_:)), for: UIControlEvents.touchUpInside)
        loginButton.setTitle("关联", for: UIControlState.normal)
        self.view.addSubview(loginButton)
        
        
    }
    func handleValueChangeAction(_ sender:UITextField) -> Void {
        
    }
    func handleUnlock(_ sender:UIButton) -> Void {
        let vc = ScanCodeViewController()
        vc.Scandelegate = self
        vc.tagString = "unlock"
        vc.scanCode = ScanFrom.ScanFromUnlock
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func handleBycicle(_ sender:UIButton) -> Void {
        let vc = ScanCodeViewController()
        vc.Scandelegate = self
        vc.tagString = "bycicle"
        vc.scanCode = ScanFrom.ScanFromBicycle
        self.navigationController?.pushViewController(vc, animated: true)

    }

    func handleActionLogin(_ sender:UIButton) -> Void {
        self.view.endEditing(true)
        if (self.tempUnlockField?.text?.isEmpty)! {
            self .showMessage(message: "请输入锁编号")
            return
        } else if (self.tempBycleNumberField?.text?.isEmpty)! {
            self .showMessage(message: "请输入轮椅编号")
            return
        }
        
    }
    func scanCodeResult(urlString: String, tagString: String) {
        if tagString == "unlock" {
            self.tempUnlockField?.text = urlString
        } else {
            self.tempBycleNumberField?.text = urlString
        }
    }
}
