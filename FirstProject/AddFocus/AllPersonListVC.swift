//
//  AllPersonListVC.swift
//  FirstProject
//
//  Created by zhujian on 18/1/20.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh


class AllPersonListVC: WMPageController {
    var viewTop:CGFloat!
    var kWMHeaderViewHeight:CGFloat = 0.0
    var kNavigationBarHeight:CGFloat = 0.0
    var kWMMenuViewHeight:CGFloat = 44.0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "关注"
  
    }
   override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    self.titleSizeNormal = 15;
    self.titleSizeSelected = 15;
    self.menuViewStyle = .line;
    self.menuItemWidth = kScreenWidth / 2;
    self.viewTop = kWMHeaderViewHeight + kNavigationBarHeight
    self.titleColorSelected = UIColor.red;
    self.titleColorNormal = UIColor.lightGray;
    
    self.navigationItem.rightBarButtonItem = CustomBarButton.createBarbuttonItem(name: "navigationbar_more", target: self, action: #selector(rightAction))

    }
    func rightAction() -> Void {
        let vc = SearchPeoPleVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
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
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    override func numbersOfTitles(in menu: WMMenuView!) -> Int {
        return 2
    }
    override func numbersOfChildControllers(in pageController: WMPageController) -> Int {
        return 2
    }
    
   override func pageController(_ pageController: WMPageController, titleAt index: Int) -> String {
        if index == 0 {
            return "我的关注"
        } else {
            return "推荐关注"
        }
    }
   override func pageController(_ pageController: WMPageController, viewControllerAt index: Int) -> UIViewController {
    if index == 0 {
        let vc1 = FocusedViewController()
        return vc1
        
    } else {
        let vc2 = FocuseingViewController()
        return vc2
    }
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
