//
//  TabBarController.swift
//  FirstProject
//
//  Created by zhujian on 17/12/29.
//  Copyright © 2017年 zhujian. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = UIColor.white;
        self.delegate = self;
        self.creatChildController();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func creatChildController() -> Void {
        self.addChildViewControllerWithClassName(viewCotroll: HomeViewController(), NormalImage: "live", SelectImage: "liveblue", title: "首页");
        self.addChildViewControllerWithClassName(viewCotroll: MessageViewController(), NormalImage: "market", SelectImage: "marketblue", title: "平台")
        self.addChildViewControllerWithClassName(viewCotroll: PageViewController(), NormalImage: "news", SelectImage: "newsetblue", title: "消息")
        self.addChildViewControllerWithClassName(viewCotroll: MyViewController(), NormalImage: "my", SelectImage: "myblue", title: "我的")

        
    }
    func addChildViewControllerWithClassName(viewCotroll:UIViewController,NormalImage:String,SelectImage:String,title:String) -> Void {
        let navigation = BaseNavigationVC.init(rootViewController: viewCotroll)
        navigation.tabBarItem = UITabBarItem.init(title: title, image: UIImage.init(named: NormalImage), selectedImage: UIImage.init(named: SelectImage))
        self.addChildViewController(navigation)
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let navi = viewController as! BaseNavigationVC;
        let top = navi.topViewController;
        if (top?.isKind(of: MessageViewController.classForCoder()))! || (top?.isKind(of: MyViewController.classForCoder()))!{
           let token = String.readToken()
            if token.isEmpty {
                let navigationVC = self.selectedViewController as! BaseNavigationVC
                let loginVC = SecondLoginViewController()
                navigationVC.pushViewController(loginVC, animated: true)
                return false;
            } else {
                return true;
            }
        } else {
            
            return true;

        }
    }


}
