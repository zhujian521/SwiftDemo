//
//  CircleModel.swift
//  FirstProject
//
//  Created by zhujian on 18/1/9.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit
import SwiftyJSON

class CircleModel: NSObject {
    var cContent:String!
    var cId:String!
    var fCreateDate:String!
    var sIsUsable:String!
    var uName:String!
    var sVideoImage:String!
    var sType:String!
    var cCreateDate:String! // 需要转换下时间戳
    var cForwardNumber:String!
    var uHeadimgurl:String!
    var fShareContent:String!
    var cCommentNumber:String!
    var cUserId:String!
    var fForwardUserId:String!
    var cLikeNumber:String!
    var cPhoto:String!
    var cContentHeight:CGFloat!
    var cPhotoArr:Array<String>!
    init(dic:JSON) {
        super.init()
        self.cContent = String.utFforNormalWord(dic["cContent"].stringValue)
        self.cContentHeight = self.stringHeightWith(fontSize: 16, width: UIScreen.main.bounds.size.width - 20, lineSpace: 5, text: self.cContent)
        self.cId = dic["cId"].stringValue
        self.fCreateDate = dic["fCreateDate"].stringValue
        self.sIsUsable = dic["sIsUsable"].stringValue
        self.uName = dic["uName"].stringValue
        self.sVideoImage = dic["sVideoImage"].stringValue
        self.sType = dic["sType"].stringValue
        self.cCreateDate = self.timeStampForData(tiemStamp: dic["cCreateDate"].intValue / 1000)
        self.cForwardNumber = dic["cForwardNumber"].stringValue
        self.uHeadimgurl = dic["uHeadimgurl"].stringValue
        self.fShareContent = dic["fShareContent"].stringValue
        self.cCommentNumber = dic["cCommentNumber"].stringValue
        self.cUserId = dic["cUserId"].stringValue
        self.fForwardUserId = dic["fForwardUserId"].stringValue
        self.cLikeNumber = dic["cLikeNumber"].stringValue
        self.cPhoto = dic["cPhoto"].stringValue
        self.cPhotoArr = self.cPhoto.components(separatedBy: ",")
    }
    func timeStampForData(tiemStamp:Int) -> String {
        let timeInterval:TimeInterval = TimeInterval(tiemStamp)
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss" //自定义日期格式
        let time:String = dateformatter.string(from: date as Date)
        return time
        
    }
    func stringHeightWith(fontSize:CGFloat,width:CGFloat,lineSpace : CGFloat,text:String)->CGFloat{
        
        let font = UIFont.systemFont(ofSize: fontSize)
        
        //        let size = CGSizeMake(width,CGFloat.max)
        
        let size = CGSize(width: width, height: CGFloat(MAXFLOAT))
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = lineSpace
        
        paragraphStyle.lineBreakMode = .byWordWrapping;
        
        let attributes = [NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        
        return rect.size.height
        
    }
    


}
