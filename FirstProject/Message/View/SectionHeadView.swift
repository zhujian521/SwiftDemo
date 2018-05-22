//
//  SectionHeadView.swift
//  FirstProject
//
//  Created by zhujian on 18/1/19.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit

class SectionHeadView: UIView {
    var tempModel:TbCircleModel!
    var tempShareButton:UIButton!
    var tempCommentButton:UIButton!
    var tempZanButton:UIButton!
    var tempRed1:UIView!
    var tempRed2:UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func creatSubViews() -> Void {
        let lin1 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 10))
        lin1.backgroundColor = UIColor.groupTableViewBackground
        self.addSubview(lin1)
        
        let view1 = UIView.init(frame: CGRect.init(x: 0, y: lin1.frame.origin.y + lin1.frame.size.height, width: kScreenWidth, height: 50))
        view1.backgroundColor = UIColor.white
        self.addSubview(view1)
        
        let shareButton = UIButton.init(frame: CGRect.init(x: 10, y: 5, width: 60, height: 30))
        view1.addSubview(shareButton)
        shareButton.setTitle("转发" + self.tempModel.tbModel.cForwardNumber, for: .normal)
        shareButton.setTitleColor(UIColor.black, for: .normal)
        shareButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.tempShareButton = shareButton
        
        let red1 = UIView.init(frame: CGRect.init(x: 10, y: 40, width: 60, height: 2))
        view1.addSubview(red1)
        red1.backgroundColor = UIColor.red
        self.tempRed1 = red1
        self.tempRed1.isHidden = false
        
        let commentButton = UIButton.init(frame: CGRect.init(x: shareButton.frame.origin.y + shareButton.frame.size.width + 50, y: 5, width: 60, height: 30))
        view1.addSubview(commentButton)
        commentButton.setTitle("评论" + self.tempModel.tbModel.cCommentNumber, for: .normal)
        commentButton.setTitleColor(UIColor.black, for: .normal)
        commentButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.tempCommentButton = commentButton
        
        let red2 = UIView.init(frame: CGRect.init(x: commentButton.frame.origin.x, y: 40, width: 60, height: 2))
        view1.addSubview(red2)
        red2.backgroundColor = UIColor.red
        red2.isHidden = true
        self.tempRed2 = red2
        
        
        let zanButton = UIButton.init(frame: CGRect.init(x: kScreenWidth - 100, y: 5, width: 80, height: 30))
        view1.addSubview(zanButton)
        zanButton.setTitle("点赞" + self.tempModel.tbModel.cLikeNumber, for: .normal)
        zanButton.setTitleColor(UIColor.black, for: .normal)
        zanButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.tempZanButton = zanButton
        
        
        
        
        let lin2 = UIView.init(frame: CGRect.init(x: 0, y: view1.frame.origin.y + view1.frame.size.height, width: kScreenWidth, height: 10))
        lin2.backgroundColor = UIColor.groupTableViewBackground
        self.addSubview(lin2)
    }
    func setCommentCount(count:Int) -> Void {
        if count == 0 {
            
        } else {
            self.tempCommentButton.setTitle("评论" + count.description, for: .normal)

        }
        
    }
    func setShareCount(count:Int) -> Void {
        if count == 0 {
            
        } else {
            self.tempShareButton.setTitle("转发" + count.description, for: .normal)
            
        }
        
    }
    func setZanCount(count:String) -> Void {
        if count == "0"  {
            
            self.tempZanButton.setTitle("点赞 0" , for: .normal)

            return
        }
        let string = "点赞 " + count
        self.tempZanButton.setTitle(string, for: .normal)
            
    }

}
