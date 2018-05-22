//
//  ToolBarView.swift
//  FirstProject
//
//  Created by zhujian on 18/1/17.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit

class ToolBarView: UIView {
    var shareButton:UIButton!
    var commentButton:UIButton!
    var zanButton:UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.creatSubViews()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func creatSubViews() -> Void {
        for index in 0..<3 {
            let btn = UIButton.init(frame: CGRect.init(x: 5 + ((kScreenWidth - 20) / 3  + 5.0 ) * CGFloat(index) , y: 0, width: (kScreenWidth - 20) / 3, height: 40))
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
            self.addSubview(btn)
            if index == 0 {
                let lin1 = UIView.init(frame: CGRect.init(x: 5 + btn.bounds.width + 2, y: 10, width: 1, height: 20))
                lin1.backgroundColor = UIColor.groupTableViewBackground
                self.addSubview(lin1)

                shareButton = btn
                btn.setTitle("分享", for: .normal)
            } else if index == 1{
 
                let lin2 = UIView.init(frame: CGRect.init(x:(5 + btn.bounds.width) * 2 + 2, y: 10, width: 1, height: 20))
                lin2.backgroundColor = UIColor.groupTableViewBackground
                self.addSubview(lin2)


                commentButton = btn
                btn.setTitle("评论", for: .normal)
                


            } else {

                zanButton = btn
                btn.setTitle("点赞", for: .normal)


            }
      
        }
        
    }
    func setNumber(tbModel:TbCircleModel) -> Void {
        shareButton.setImage(UIImage.init(named: "timeline_icon_retweet"), for: .normal)
        commentButton.setImage(UIImage.init(named: "timeline_icon_comment"), for: .normal)
        zanButton.setImage(UIImage.init(named: "timeline_icon_unlike"), for: .normal)


        if tbModel.tbModel.cForwardNumber != "0" {
            shareButton.setTitle(tbModel.tbModel.cForwardNumber, for: .normal)
        } else {
            shareButton.setTitle("分享", for: .normal)
        }
        if tbModel.tbModel.cCommentNumber != "0" {
            commentButton.setTitle(tbModel.tbModel.cCommentNumber, for: .normal)

        } else {
            commentButton.setTitle("评论", for: .normal)

        }
        if tbModel.tbModel.cLikeNumber != "0" {
            zanButton.setTitle(tbModel.tbModel.cLikeNumber, for: .normal)
            
        } else {
            zanButton.setTitle("点赞", for: .normal)

        }

    }
    func setButtonTitle(str1:String,str2:String,str3:String) -> Void {
        shareButton.setTitle(str1, for: .normal)
        commentButton.setTitle(str2, for: .normal)
        zanButton.setTitle(str3, for: .normal)
        shareButton.backgroundColor = UIColor.lightGray
        commentButton.backgroundColor = UIColor.lightGray
        zanButton.backgroundColor = UIColor.lightGray




    }

}
