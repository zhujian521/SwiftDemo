//
//  CommonPostModel.swift
//  FirstProject
//
//  Created by zhujian on 18/2/8.
//  Copyright © 2018年 zhujian. All rights reserved.
//

import UIKit
import SwiftyJSON

class CommonPostModel: NSObject {
    var pUserId:String!
    var uName:String!
    var pContent:String!
    var pId:String!
    var pPublishType:String!
    var fName:String!
    var pType:String!
    var pPhoto:String!
    var uHeadimgurl:String!
    var pTitle:String!
    var pUserType:String!
    var pCreateDate:String!
    var pIsHighlight:String!
    var pCommentNumber:String!
    var pWatchNumber:String!
    var cContentHeight:CGFloat!
    var cPhotoArr:Array<String>!


    init(dic:JSON) {
        super.init()
        self.pUserId = dic["pUserId"].stringValue
        self.uHeadimgurl = dic["uHeadimgurl"].stringValue
        self.pCreateDate = self.timeStampForData(tiemStamp: dic["pCreateDate"].intValue / 1000)
        
        self.pId = dic["pId"].stringValue
        self.uName = dic["uName"].stringValue
        self.pTitle = String.utFforNormalWord(dic["pTitle"].stringValue)
        self.cContentHeight = self.stringHeightWith(fontSize: 16, width: UIScreen.main.bounds.size.width - 20, lineSpace: 5, text: self.pTitle)
        self.pCommentNumber = dic["pCommentNumber"].stringValue
        self.pPhoto = dic["pPhoto"].stringValue
        if self.pPhoto.isEmpty {
            
        } else {
            self.cPhotoArr = self.pPhoto.components(separatedBy: ",")
 
        }

        
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
