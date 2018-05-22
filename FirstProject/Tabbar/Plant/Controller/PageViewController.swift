//
//  PageViewController.swift
//  FirstProject
//
//  Created by zhujian on 18/2/5.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit
import SwiftyJSON

class PageViewController: WMPageController {
    var subTitles = [String]()
    var subUrls = [String]()
    var addTitlesModel = [MyForumModel]()
    var subControllers = [ViewController]()
    var viewTop:CGFloat!
    var kWMHeaderViewHeight:CGFloat = 0.0
    var kNavigationBarHeight:CGFloat = 0.0
    var kWMMenuViewHeight:CGFloat = 44.0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "资讯";
        let notificationName = Notification.Name(rawValue: "loginSuccess")
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(loginSuccessAction(notification:)),
                                               name: notificationName, object: nil)
        self.requestMeApp()
        self.getAllForumApp()
        self.navigationItem.rightBarButtonItem = CustomBarButton.createBarbuttonItem(name: "ic_mail-15", target: self, action: #selector(rightAction))
        


    }
    
    func rightAction() -> Void {
        let vc = PlateViewController()
        vc.subUrls = self.subUrls
        vc.subTitles = self.subTitles
        vc.addTitlesModel = self.addTitlesModel
        self.present(vc, animated: true, completion: nil)
        
    }
    func loginSuccessAction(notification: Notification) {
        self.requestMeApp()

    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.subTitles.append("头条")
        self.subTitles.append("江苏")
        self.subUrls.append("头条")
        self.subUrls.append("江苏")
        self.titleSizeNormal = 14
        self.titleSizeSelected = 17
        self.menuViewStyle = .line
        self.menuViewLayoutMode = .left
        self.menuItemWidth = kScreenWidth / 5
        self.automaticallyCalculatesItemWidths = true
        self.itemMargin = 20

    }

    convenience  init() {
        
        var nibNameOrNil = String?("WMPageController")
        
        //考虑到xib文件可能不存在或被删，故加入判断
        
        if Bundle.main.path(forResource: nibNameOrNil, ofType: "xib") == nil
            
        {
            nibNameOrNil = nil
            
        }
        self.init(nibName: nibNameOrNil, bundle: nil)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func numbersOfTitles(in menu: WMMenuView!) -> Int {
        return self.subTitles.count
    }
    override func numbersOfChildControllers(in pageController: WMPageController) -> Int {
        return self.subTitles.count
    }
    
    override func pageController(_ pageController: WMPageController, titleAt index: Int) -> String {
       return self.subTitles[index]
    }

    override func pageController(_ pageController: WMPageController, viewControllerAt index: Int) -> UIViewController {
        if  index == 0 {
            let vc = NewSViewController()
            return vc
        }
        if index == 1 {
            let vc = AddressViewController()
            vc.cityString = self.subUrls[index]
            return vc
 
        }
        let vc = ForumViewController()
        vc.fidString = self.subUrls[index]
        return vc
        
    }
    override func pageController(_ pageController: WMPageController, preferredFrameFor menuView: WMMenuView) -> CGRect {
        let rect = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: self.kWMMenuViewHeight)
        return rect
    }
    override func pageController(_ pageController: WMPageController, preferredFrameForContentView contentView: WMScrollView) -> CGRect {
        let originY = 0 + kWMMenuViewHeight;
        let rect = CGRect.init(x: 0, y: originY, width: kScreenWidth, height: self.view.frame.size.height - originY)
        return rect
    }
    func requestMeApp() -> Void {
        let tokenID = String.readToken()
        if tokenID.isEmpty {
            return
        }
        let param = ["TokenID":tokenID]
        var url =  String.readServerIP()
        url = url + String.readMeApp()
        NetWorkWeather.sharedInstance.getRequest(urlString: url, params: param, success: { (json) -> Void in
            let jsonDic = JSON(json)
            print(jsonDic)
            let status:String = jsonDic["status"].stringValue
//            let message:String = jsonDic["message"].stringValue
            if status == "0" {
            } else {
                let myforums = jsonDic["myforums"].arrayValue
                for item in myforums {
                    let model = MyForumModel.init(dic: item)
                    self.subTitles.append(model.fName)
                    self.subUrls.append(model.fId)
                }
                    self.reloadData()

                
            }
            
            
        }) { (error) in
            
        }

    }
    func getAllForumApp() -> Void {
        
        let tokenID = String.readToken()
        if tokenID.isEmpty {
            return
        }
        let param = ["TokenID":tokenID]
        var url =  String.readServerIP()
        url = url + String.addForumApp()
        NetWorkWeather.sharedInstance.getRequest(urlString: url, params: param, success: { (json) -> Void in
            let jsonDic = JSON(json)
            print(jsonDic)
            let status:String = jsonDic["status"].stringValue
            if status == "0" {
            } else {
                let myforums = jsonDic["forums"].arrayValue
                for item in myforums {
                    let model = MyForumModel.init(dic: item)
                    print(model.fId)
                    print(model.fName)
                    self.addTitlesModel.append(model)
//                    self.subTitles.append(model.fName)
//                    self.subUrls.append(model.fId)
                }
                
                
            }
            
            
        }) { (error) in
        }
 
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
