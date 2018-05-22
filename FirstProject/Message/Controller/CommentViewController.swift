//
//  CommentViewController.swift
//  FirstProject
//
//  Created by zhujian on 18/1/17.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol CommentViewControllerDelegate {
    func sendCommentAtRow(row:Int) -> Void
}
class CommentViewController: BaseViewController {
    var tempModel:TbCircleModel!
    var tempCustomText = CustomTextView()
    var tempRow:Int!
    var delegate:CommentViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发评论"
        let rightBar = UIBarButtonItem.init(title: "提交", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleSave))
        rightBar.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.black,NSFontAttributeName:UIFont.systemFont(ofSize: 15)], for: .normal)
        self.navigationItem.rightBarButtonItem = rightBar

        
        let textView = CustomTextView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        tempCustomText = textView
        self.view.addSubview(textView)

    }
    func handleSave() -> Void {
        self.view.endEditing(true)
        if tempCustomText.textViewTest.text.isEmpty {
            self.showMessage(message: "请输入评论")
            return
        }
        var param = ["TokenID":String.readToken()]
        param.updateValue(tempModel.tbModel.cId, forKey: "cId")
        param.updateValue(String.forEncoding(tempCustomText.textViewTest.text), forKey: "content")
        self.showMBProgress()
        NetWorkWeather.sharedInstance.postRequest(urlString: self.getUserNMGBaseUrl(string: "commentAPP"), params: param, success: { (json) -> Void in
            self.hideMBProgress()
            let jsonDic = JSON(json)
            let message:String = jsonDic["message"].stringValue
            let status:String = jsonDic["status"].stringValue
            self.showMessage(message: message)
            if status == "1" {
                self.delegate?.sendCommentAtRow(row: self.tempRow)
                self.navigationController!.popViewController(animated: true)
            }

        }) { (errot) in
            self.hideMBProgress()
            self.showMessage(message: "评论不能过长")

        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
