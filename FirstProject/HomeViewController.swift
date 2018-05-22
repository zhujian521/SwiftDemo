//
//  HomeViewController.swift
//  FirstProject
//
//  Created by zhujian on 17/11/23.
//  Copyright © 2017年 zhujian. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "平台"
        self.creatButton()

    }
    func creatButton() -> Void {
        let titleArr = ["立即关联","取消关联","关联历史","查找位置","退出登录"]
        for index in 0...titleArr.count - 1 {
            let btn = UIButton.init(frame: CGRect.init(x: 15, y: 30 + (44 + 20) * index, width: Int(SCREEN_WIDTH - 30), height: 44))
            btn.setUpButton()
            btn.tag = index
            btn.addTarget(self, action: #selector(handleAciton(_:)), for: UIControlEvents.touchUpInside)
            btn.setTitle(titleArr[index], for: UIControlState.normal)
            self.view.addSubview(btn)
            
        }
    }
    func handleAciton(_ sender:UIButton) -> Void {
        print("====\(sender.tag)")
        if sender.tag == 4 {
            let alertVC = UIAlertController.init(title: "提示", message: "退出登录", preferredStyle: UIAlertControllerStyle.alert)
            let acSure = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) -> Void in
                String.cleanData()
                String.cleanToken()
                self.changeLogInAsWindow()
            })
            let acCancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (UIAlertAction) -> Void in
                print("click Cancel")
            }
            alertVC.addAction(acCancel)
            alertVC.addAction(acSure)
            self.present(alertVC, animated: true, completion: { })
        } else if sender.tag == 2 {
            let historyVC = HistoryVC()
            historyVC.title = sender.titleLabel?.text
            self.navigationController?.pushViewController(historyVC, animated:true)
      
        } else if sender.tag == 0 {
            let addVC = AddRelationViewController()
            addVC.title = sender.titleLabel?.text
            self.navigationController?.pushViewController(addVC, animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
