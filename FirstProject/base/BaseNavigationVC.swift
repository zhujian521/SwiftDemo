//
//  BaseNavigationVC.swift
//  FirstProject
//
//  Created by zhujian on 17/12/29.
//  Copyright © 2017年 zhujian. All rights reserved.
//

import UIKit

class BaseNavigationVC: UINavigationController ,UINavigationControllerDelegate{
    
    var popDelegate:AnyObject?;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.popDelegate = self.interactivePopGestureRecognizer?.delegate;
        self.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true;
            let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                         action: nil)
            spacer.width = -10;

            let leftButton =  CustomBarButton.createBarbuttonItem(name: "navigationbar_back", target: self, action: #selector(handleAcitonBack))
//                UIBarButtonItem.init(image: UIImage.init(named: "navigationbar_back"), style: UIBarButtonItemStyle.done, target: self, action: #selector (handleAcitonBack));
            viewController.navigationItem.leftBarButtonItems = [spacer,leftButton];

        }
        super.pushViewController(viewController, animated: true)
    }
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if (viewController == self.viewControllers[0]) {
            //如果在根控制器下不将interactivePopGestureRecognizer.delegate置回原有delegate
            //再左滑一次，点击跳转回死掉
            self.interactivePopGestureRecognizer?.delegate = self.popDelegate as! UIGestureRecognizerDelegate?;
        } else {
            //如果是自定义左边的返回按钮必须清空interactivePopGestureRecognizer.delegate才能使用左滑返回
            self.interactivePopGestureRecognizer?.delegate = nil;
        }

    }
    func handleAcitonBack() -> Void {
        self.popViewController(animated: true)
    }


}
