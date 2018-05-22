//
//  ViewController.swift
//  FirstProject
//
//  Created by zhujian on 17/10/23.
//  Copyright © 2017年 zhujian. All rights reserved.
//

import UIKit

class ViewController: BaseViewController,UITextFieldDelegate,OneViewControllerProtol{
    var tempLable :UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        creatLabel()
        creatButton()
//      creatImage()
//      creatTextField()
        
    
    }
    func creatLabel() -> Void {
        let label = UILabel (frame: CGRect(x:20,y:150,width:200,height:20))
        label.textAlignment = NSTextAlignment.center
        label.text = "我的第一个标签";
        self.view.addSubview(label)
        
        let label2 = UILabel (frame:CGRect(x:20,y:170,width:200,height:20))
        label2.text = "我的第二个标题"
        tempLable = label2
        self.view.addSubview(label2)
        label2.font = UIFont.systemFont(ofSize: 14)
        label2.textColor = UIColor.blue
        label2.textAlignment = NSTextAlignment.right
        
        let label3 = UILabel (frame: CGRect(x:20,y:200,width:200,height:150))
        label3.text = "我刚回家我刚好几万范围后返回我发复活我复活我方复活我复活我方范围后返回我"
        label3.numberOfLines = 7
        self.view.addSubview(label3)
        
        let label4 = UILabel (frame: CGRect(x:200,y:100,width:200,height:30))
        self.view.addSubview(label4)
        let attri = NSMutableAttributedString(string: "我的个性化文本")
        attri.addAttributes([NSFontAttributeName:UIFont.boldSystemFont(ofSize: 13),NSForegroundColorAttributeName:UIColor.blue],range: NSRange(location:0,length:2))
        attri.addAttributes([NSFontAttributeName:UIFont.boldSystemFont(ofSize: 16),NSForegroundColorAttributeName:UIColor.red], range: NSMakeRange(3, 3))
        label4.attributedText = attri;
        self.view.addSubview(label4)
        
    }
    func creatButton() -> Void {
        let buttonOne = UIButton (type: UIButtonType.system)
        buttonOne.frame = CGRect(x:20,y:70,width:100,height:30)
        buttonOne.backgroundColor = UIColor.purple
        buttonOne.setTitle("标题", for: UIControlState())
        buttonOne.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.view.addSubview(buttonOne)
        buttonOne.addTarget(self, action: #selector(touchBegin), for: UIControlEvents.touchUpInside)
        buttonOne.setBackgroundImage(UIImage(named: "chongzhi_sel"), for: UIControlState())
        
        let buttonTwo = UIButton (type: UIButtonType.custom)
        buttonTwo.frame = CGRect(x:140,y:70,width:100,height:30)
        buttonTwo.backgroundColor = UIColor.purple
        buttonTwo.setTitle("标题", for: UIControlState())
        buttonTwo.setTitleColor(UIColor.black, for: UIControlState.normal)
        self.view.addSubview(buttonTwo)
        buttonTwo.setImage(UIImage(named: "home_cyclingTime"), for: UIControlState.normal)
        
    }
    func creatImage() {
        let image = UIImage(named: "icon_unclock_bike")
        let imageView = UIImageView(image:image)
        imageView.frame = CGRect(x:30,y:60,width:200,height:200)
        self.view.addSubview(imageView)
    }
    func touchBegin() {
        print("点击")
        let oneVC = OneViewController();
        oneVC.delegate = self
        oneVC.data = "属性传递值"
        self.navigationController?.pushViewController(oneVC, animated: true);
        
        
    }
    func sendData(data: String) {
        if !data.isEmpty {
            tempLable?.text = data

        }
    }
    func creatTextField(){
        let userName = UITextField (frame: CGRect(x:20,y:30,width:200,height:30))
        userName.borderStyle = UITextBorderStyle.roundedRect
        userName.textColor = UIColor.red
        userName.textAlignment = NSTextAlignment.left
        userName.clearButtonMode = UITextFieldViewMode.always
//        userName.keyboardType = UIKeyboardType.numberPad
        userName.placeholder = "输入电话号码"
        userName.delegate = self
        self.view.addSubview(userName)
        
        let imageView1 = UIImageView (image: UIImage(named: "home_jubao"))
        imageView1.frame = CGRect(x:0,y:0,width:30,height:30)
        userName.leftView = imageView1
        
        let imageView2 = UIImageView (image: UIImage(named: "home_cyclingTime"))
            
        
        userName.rightView = imageView2
        userName.leftViewMode = UITextFieldViewMode.always
        userName.rightViewMode = UITextFieldViewMode.always

        
        
        
        
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
//代理实现
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)  {
        print("输入框已经开始编辑")
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if (textField.text?.characters.count)! >= 11 {
//            return true
//        }
//        if (string.characters.first)! >= "0" && (string.characters.first)! <= "9"{
//            return true
//        } else {
//            return false
// 
//        }
        print("===\(string)++\(string.characters.first)==\(textField.text)");

        if let temp = string.characters.first {
            if temp >= "0" && temp <= "9" {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }

}

