//
//  OneViewController.swift
//  FirstProject
//
//  Created by zhujian on 17/11/21.
//  Copyright © 2017年 zhujian. All rights reserved.
//

import UIKit

protocol OneViewControllerProtol {
      func sendData(data:String) -> Void
}

class OneViewController: BaseViewController {
    var data:String?
    var delegate:OneViewControllerProtol?
    var tempField:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let titleLabel = UILabel.init(frame: CGRect.init(x: 10, y: 80, width: 100, height: 30));
        titleLabel.textColor = UIColor.black;
        titleLabel.text = data
        titleLabel.backgroundColor = UIColor.red
        self.view.addSubview(titleLabel);
        
        let userName = UITextField.init(frame: CGRect.init(x: 10, y: 130, width: 200, height: 30))
        userName.placeholder = "请输入账号"
        userName.borderStyle = UITextBorderStyle.roundedRect
        userName.backgroundColor = UIColor.lightGray
        tempField = userName
        self.view .addSubview(userName);
        
        let btnBack = UIButton.init(frame: CGRect.init(x: 10, y: 200, width: UIScreen.main.bounds.width - 20, height: 44))
        self.view.addSubview(btnBack)
        btnBack .setTitle("返回", for: UIControlState.normal)
        btnBack.backgroundColor = UIColor.blue
        btnBack.setTitleColor(UIColor.white, for: UIControlState.normal)
        btnBack.addTarget(self, action: #selector(handleBackAction(_:)), for: UIControlEvents.touchUpInside)
        btnBack.layer.masksToBounds = true
        btnBack.layer.cornerRadius = 4
        
        
        
        
    }
    func handleBackAction(_ button:UIButton) -> Void {
        if let text = tempField?.text {
            delegate?.sendData(data:text)
 
        }
        self.navigationController!.popViewController(animated: true)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
