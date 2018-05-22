//
//  CustomBarButton.swift
//  FirstProject
//
//  Created by zhujian on 18/1/20.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit

class CustomBarButton: UIBarButtonItem {
    class func createBarbuttonItem(name: String,target: Any?, action: Selector) -> UIBarButtonItem{
        
        let rightBtn = UIButton()
        rightBtn.setImage(UIImage(named: name), for: UIControlState.normal)
        rightBtn.setImage(UIImage(named: name + "_highlighted"), for: UIControlState.highlighted)
        // button自适应大小
        rightBtn.sizeToFit()
        rightBtn.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        return UIBarButtonItem(customView:rightBtn)
        
    }
   class func creatTextBarbuttonItem(name:String,target:Any?,action:Selector) -> UIBarButtonItem {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 0, y: 0, width: 44, height: 40)
        btn.setTitle(name, for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        return UIBarButtonItem(customView:btn)

    }
    
}
