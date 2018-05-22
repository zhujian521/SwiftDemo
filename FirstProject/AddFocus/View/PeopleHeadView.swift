//
//  PeopleHeadView.swift
//  FirstProject
//
//  Created by zhujian on 18/1/22.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit

class PeopleHeadView: UIView {
    var tempName:UILabel!
    var tempImage:UIImageView!
    var tempTitle:UILabel!
    var tempFocus:UILabel!
    var tempFans:UILabel!
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
        let backImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.addSubview(backImage)
        backImage.image = UIImage.init(named: "WechatIMG2")
        
        let uHeadImage = UIImageView.init(frame: CGRect.init(x: 10, y: 10, width: 50, height: 50))
        uHeadImage.backgroundColor = UIColor.white
        uHeadImage.layer.masksToBounds = true
        uHeadImage.layer.cornerRadius = 25
        self.addSubview(uHeadImage)
        self.tempImage = uHeadImage
        
        let uName = UILabel.init(frame: CGRect.init(x: uHeadImage.frame.origin.x + uHeadImage.frame.size.width + 10, y: 10, width: 160, height: 25))
        uName.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(uName)
        uName.textColor = UIColor.white
        self.tempName = uName
        
        let uTitle = UILabel.init(frame: CGRect.init(x: uHeadImage.frame.origin.x + uHeadImage.frame.size.width + 10, y: uName.frame.origin.y + uName.frame.size.height + 10, width: 130, height: 20))
        uTitle.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(uTitle)
        uTitle.textColor = UIColor.white
        self.tempTitle = uTitle
        
        let focusCount = UILabel.init(frame: CGRect.init(x: kScreenWidth - 120, y: 10, width: 100, height: 25))
        focusCount.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(focusCount)
        focusCount.textAlignment = .right
        focusCount.textColor = UIColor.white
        self.tempFocus = focusCount
        
        let fansCount = UILabel.init(frame: CGRect.init(x: kScreenWidth - 120, y: focusCount.frame.origin.y + focusCount.frame.size.height + 10, width: 100, height: 25))
        fansCount.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(fansCount)
        fansCount.textColor = UIColor.white
        fansCount.textAlignment = .right
        self.tempFans = fansCount

    }
    func configureModel(model:UserInfoAuthenModel) -> Void {
        self.tempName.text = model.uName
        self.tempTitle.text = model.aEnterpriseName
        self.tempFocus.text = "关注" + model.attentionNum
        self.tempFans.text = "粉丝" + model.fanNum
        let urlString = self.getHeadimgurl(path:model.uHeadimgurl)
        let url = NSURL.init(string:urlString)
        self.tempImage.sd_setImage(with: url as URL!, placeholderImage: UIImage.init(named: "avatar"))
        
    }
    func getHeadimgurl(path:String?) -> String {
        var url = "http://120.77.211.200/"
        url = url + "image/getImg?path="
        if path != nil {
            url = url + path!
            url = NSString.forUTF(url)
            return url
            
        }
        return url
    }



}
