//
//  CommentStringModel.swift
//  FirstProject
//
//  Created by zhujian on 18/1/18.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit
import SwiftyJSON

class CommentStringModel: NSObject {

    var cId:String!
    var uHeadimgurl:String!
    var cCreateDate:String!
    var cCircleId:String!
    var uName:String!
    var cContent:String!
    var cCommentUserId:String!
    var cContentHeight:CGFloat!
    
    init(dic:JSON) {
        super.init()
        self.cId = dic["cId"].stringValue
        self.uHeadimgurl = dic["uHeadimgurl"].stringValue
        self.cCreateDate = self.timeStampForData(tiemStamp: dic["cCreateDate"].intValue / 1000)
        
        self.cCircleId = dic["cCircleId"].stringValue
        self.uName = dic["uName"].stringValue
        self.cContent = String.utFforNormalWord(dic["cContent"].stringValue)
        self.cCommentUserId = dic["cCommentUserId"].stringValue
        self.cContentHeight = self.stringHeightWith(fontSize: 16, width: UIScreen.main.bounds.size.width - 20, lineSpace: 5, text: self.cContent)
        
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
