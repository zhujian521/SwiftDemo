//
//  ShowMenuView.swift
//  FirstProject
//
//  Created by zhujian on 18/1/19.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit

typealias HandleBlock = (String) -> Void
class ShowMenuView: UIView {
    var postValueBlock:HandleBlock?
    init(frame:CGRect,titleArr:Array<String>) {
        super.init(frame: frame)
        let backGroundView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        backGroundView.backgroundColor = UIColor.black
        backGroundView.alpha = 0.3
        self.addSubview(backGroundView)
        
        let tempY = kScreenHeight -  CGFloat(44 * titleArr.count)  - 10
        for index in titleArr.indices {
            
            let btn = UIButton.init()
            if index == titleArr.count - 1 {
                btn.frame = (frame: CGRect.init(x: 0, y: tempY + CGFloat(44 * index) + 10, width: kScreenWidth, height: 43))

            } else {
                btn.frame = (frame: CGRect.init(x: 0, y:tempY + CGFloat(44 * index), width: kScreenWidth, height: 43))
 
            }
            btn.backgroundColor = UIColor.white
            btn.setTitle(titleArr[index], for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.addTarget(self, action: #selector(handleAction(_ : )), for: .touchUpInside)
            self.addSubview(btn)
        }
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(handleTapAction))
        backGroundView.addGestureRecognizer(tapGesture)
    }
    func handleAction(_ sender:UIButton) -> Void {
        self.postValueBlock!((sender.titleLabel?.text)!)
        self.hideView()
    }
    func showView(navigaiton:TabBarController) -> Void {
        navigaiton.view.addSubview(self)
    }
    func hideView() -> Void {
        self.removeFromSuperview()
    }
    func handleTapAction() -> Void {
        self.hideView()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
